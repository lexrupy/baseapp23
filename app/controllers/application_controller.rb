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

  # Helpers to expire session in X minutes
  def update_activity_time
    session[:expires_at] = (configatron.session_time_out.to_i || 10).minutes.from_now
  end

  def expiry_time
    session[:expires_at] || 3.days.from_now
  end

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
      flash[:notice] = "Your session has been expired by inactivity." if do_flash
      redirect_to new_session_url
    end
  end

  def admin_layout?
    self.class.name.starts_with?("Admin::")
  end

  # Return the value for a given setting
  def s(identifier)
    Setting.get(identifier)
  end

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end

  def logged_in?
    !current_user_session.nil?
  end

  def authorized?(resource=nil)
    if current_user
      if resource.nil?
        ctrl_name = self.class.controller_name_for_authorization
        resource = "#{ctrl_name}-#{action_name}"
      end
#      current_user.roles.any? do |role|
#        available_resources_for_role(role).include?(resource)
#      end
      current_user.have_access?(resource)
    else
      false
    end
  end

  def authorize_user(role=nil)
    unless current_user
      store_location
      flash[:notice] = "You need to be logged in to access this page!"
      redirect_to new_session_url
      return false
    else
      return not_found unless (authorized? && (role.nil? || current_user.has_role?(role)))
    end
  end

  def self.require_role(role, options={})
    # Configure the security resources
    resources = @security_resources || {}
    resources[role] ||= {}
    resources[role] = resources[role].merge(:except => options[:except].to_a, :only => options[:only].to_a)
    instance_variable_set(:"@security_resources", resources)
    # Thefine the filter method
    instance_variable_set(:"@user_#{role.to_s}_role", role)
    define_method("check_#{role.to_s}_role") do
      return not_found unless current_user.has_role?(self.class.instance_variable_get(:"@user_#{role.to_s}_role"))
    end
    before_filter :"check_#{role.to_s}_role", options
  end

  def available_resources_for_role(role)
    resources = self.class.instance_variable_get(:"@security_resources")
    valid_methods = self.class.public_instance_methods(false)

    unless resources[role].nil?
      only, except = resources[role][:only].map {|m| m.to_s }, resources[role][:except].map {|m| m.to_s }
      valid_methods = valid_methods.select { |m| !only.include?(m) } unless only.blank?
      valid_methods = valid_methods.select { |m| except.include?(m) } unless except.blank?
    end

    valid_methods.inject([]) do |res, method|
      res << "#{self.class.controller_name_for_authorization}-#{method}"
    end
  end

  def self.controller_name_for_authorization
    controller_path.gsub(/\//,":")
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def not_found
    render :file => "#{RAILS_ROOT}/public/404.html"
    return false
  end

end

