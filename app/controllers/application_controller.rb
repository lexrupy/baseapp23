# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time
  filter_parameter_logging :password, :password_confirmation
  helper_method :s, :current_user_session, :current_user,
                :logged_in?, :admin_layout?, :authorized?
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :authorize_user, :session_expiry
  after_filter :update_activity_time

  private

  # Update activity time.
  #
  # Update the expiration time according to configuration (or to 10 minutes if configuration not set)
  def update_activity_time
    session[:expires_at] = (configatron.session_time_out.to_i || 10).minutes.from_now
  end


  # Expiry time.
  #
  # Return the current expiry time defined by update_activity_time if set, or
  # return a default expiry time of 3 days for new sessions.
  def expiry_time
    session[:expires_at] || 3.days.from_now
  end

  # Session expiry
  #
  # Check the time for expiration of session. If no time remaining, expires the
  # current session redirecting the user to the new session path (Login page)
  def session_expiry
    @time_left = (expiry_time - Time.now).to_i
    do_flash = false
    unless @time_left > 0
      unless current_user_session.nil?
        current_user_session.destroy
        do_flash = true
      end
      reset_session
      store_location
      flash[:notice] = t('app.security.session_expired',
        :default => "Your session has been expired by inactivity.") if do_flash
      redirect_to new_session_url
    end
  end

  # Authorize user.
  #
  # This method is set as a before filter in application to test if user is currently
  # logged in. It redirects the user for login page if user is not logged in
  def authorize_user
    unless current_user
      store_location
      flash[:notice] = t('app.security.unauthorized_access', :default => "You need to be logged in to access this page!")
      redirect_to new_session_url
      return false
    else
      return not_found unless authorized?
    end
  end

  # Admin layout.
  #
  # Return true if current controller is scoped in Admin section
  def admin_layout?
    self.class.name.starts_with?("Admin::")
  end

  # Setting
  #
  # Return the value for a given setting identifier
  def s(identifier)
    Setting.get(identifier)
  end

  # Current User Session.
  #
  # Return the current user session object
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  # Current User.
  #
  # Return the current active user.
  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end

  # Logged in.
  #
  # Return true if current user session is set
  def logged_in?
    !current_user_session.nil?
  end

  # Authorized?
  #
  # Test if current user is authorized for access to given resource
  # +options+ Options to determine the resource
  # Valid Options:
  #   :resource - Manually specified resource name
  #
  #   :controller - This needs to be used in conjunct with :action option, providing
  #                 a way to check if user is authorized to access the given action in
  #                 the given controller.
  #   :action     - See :controller option
  def authorized?(options={})
    if current_user
      ctrl = self.class
      action = action_name
      unless options[:controller].blank?
        if options[:action].blank?
          raise "[BASEAPP ERROR] You need to define an action when authorizing via controller"
        end
        action = options[:action]
        ctrl = options[:controller]
      end
      resource = options[:resource].blank? ? "#{ctrl.controller_name_for_authorization}-#{action}" : options[:resource]
      current_user.has_role?(ctrl.required_roles_for_method(action)) && current_user.have_access?(resource)
    else
      false
    end
  end

  # Require role.
  #
  # This method was based on role requeriment plugin, but simplified.
  # This method restrict acces to a entire cotnroller or specific actions to a
  # predefined role (group of users).
  #
  # Examples:
  #
  # This will restrict all methods on Tickets controller to admin role.
  #
  # TicketsController < ApplicationController
  # require_role :admin
  #
  # def index
  #    ...
  # end
  #
  # end
  #
  # This will restrict only index method on Tickets controller to admin role.
  #
  # TicketsController < ApplicationController
  # require_role :admin, :only => :index
  #
  # def index
  #    ...
  # end
  #
  # end
  #
  #
  # This will restrict all methods except index on Tickets controller to admin role.
  #
  # TicketsController < ApplicationController
  # require_role :admin, :except => [:index]
  #
  # def index
  #    ...
  # end
  #
  # end
  #
  # :except and :only options also accepts an array of options, just like a filter (before_filter)
  #
  def self.require_role(role, options={})
    # Configure the security resources
    resources = @security_resources || {}
    resources[role] ||= {}
    resources[role] = resources[role].merge(
      :except => options[:except].to_a.map {|m| m.to_s },
      :only => options[:only].to_a.map {|m| m.to_s }
    )
    instance_variable_set(:"@security_resources", resources)
    # Thefine the filter method
    instance_variable_set(:"@user_#{role.to_s}_role", role)
    define_method("check_#{role.to_s}_role") do
      return not_found unless current_user.has_role?(self.class.instance_variable_get(:"@user_#{role.to_s}_role"))
    end
    private :"check_#{role.to_s}_role"
    before_filter :"check_#{role.to_s}_role", options
  end

  # Required roles for method
  #
  # Return the roles required for execute the given method in this controller
  # +method+ The method to test what roles are required
  def self.required_roles_for_method(method)
    resources = @security_resources
    unless resources.nil?
      roles ||= begin
        resources.keys.select do |role|
          unless resources[role].nil?
            except, only = resources[role][:except], resources[role][:only]
            if except.blank? && only.blank?
              true
            else
              # INFO: Only supports one of "except" or "only" at time
              except.blank? ? only.include?(method.to_s) : !except.include?(method.to_s)
            end
          end
        end
      end
    else
      []
    end
  end

  # Required roles for method
  #
  # Alias for self.required_roles_for_method
  def required_roles_for_method(method)
    self.class.required_roles_for_method(method)
  end

  # Controller Name for Authorization
  #
  # Return the controller name formatted for authorization
  # admin/users => admin:users
  def self.controller_name_for_authorization
    controller_path.gsub(/\//,":")
  end

  # Store location.
  #
  # Store current uri for later use.
  # Example:
  # A user requested some page, that needs authentication, so user will be redirected
  # to authentication page. When user authenticates should be redirected to the
  # first requested page.
  def store_location
    session[:return_to] = request.request_uri
  end

  # Redirect back or default.
  #
  # Redirects user to the previous saved location (store_location) or to the given
  # default if no location was stored.
  # +default+ default location where user should be redirected in case of no location
  # stored.
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # Not Found.
  #
  # Render the not found page (404)
  def not_found
    #render :file => "#{RAILS_ROOT}/public/404.html"
    render_optional_error_file(404)
    return false
  end

end

