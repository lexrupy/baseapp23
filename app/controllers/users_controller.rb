class UsersController < ApplicationController
  #skip_before_filter :verify_authenticity_token, :only => :create
  skip_before_filter :authorize_user,
    :only => [:new, :troubleshooting, :clueless, :forgot_login,
              :forgot_password, :reset_password, :create, :activate]

  before_filter :find_user,
    :only => [:profile,
              :destroy,
              :edit_password,   :update_password,
              :edit_email,      :update_email]

  layout 'login'

  def new
    @user = User.new
  end

  def troubleshooting
    #render :layout => 'login'
  end

  def clueless
    #render :layout => 'login'
  end

  def forgot_login
    if request.put?
      begin
        @user = User.find_by_email(params[:email], :conditions => ['NOT state = ?', 'deleted'])
      rescue
        @user = nil
      end
      if @user.nil?
        flash.now[:error] = t('users.forgot_login.flash.error', :default => 'No account was found with that email address.')
      else
        UserMailer.deliver_forgot_login(@user)
      end
    else
      # Render forgot_login.html.erb
    end
    render :layout => 'login'
  end

  def forgot_password
    if request.put?
      @user = User.find_by_login_or_email(params[:email_or_login])
      if @user.nil?
        flash.now[:error] = t('users.forgot_password.flash.error', :default => 'No account was found by that login or email address.')
      else
        @user.forgot_password if @user.active?
      end
    else
      # Render forgot_password.html.erb
    end
    #render :layout => 'login'
  end

  def reset_password
    begin
      @user = User.find_by_password_reset_code(params[:password_reset_code])
    rescue
      @user = nil
    end
    unless @user.nil? || !@user.active?
      @user.reset_password!
    end
    #render :layout => 'login'
  end

  def create
    create_new_user(params[:user])
  end

  def activate
    user = User.find_by_perishable_token(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = t('users.activate.flash.
                      notice', :default => "Signup complete! Please sign in to continue.")
      redirect_to login_path
    when params[:activation_code].blank?
      flash[:error] = t('users.activate.flash.error.activation_code_blank',
                      :default => "The activation code was missing.  Please follow the URL from your email.")
      redirect_back_or_default(root_path)
    else
      flash[:error]  = t('users.activate.flash.error.activation_code_invalid',
                      :default => "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in.")
      redirect_back_or_default(root_path)
    end
  end

  def edit_password
    # render edit_password.html.erb
  end

  def update_password
    if current_user == @user
      current_password, new_password, new_password_confirmation = params[:current_password], params[:new_password], params[:new_password_confirmation]
      if @user.valid_password? current_password
        if new_password == new_password_confirmation
          if new_password.blank? || new_password_confirmation.blank?
            flash[:error] = t('users.update_password.flash.error.blank_password', :default => "You cannot set a blank password.")
            redirect_to edit_password_user_url(@user)
          else
            @user.password = new_password
            @user.password_confirmation = new_password_confirmation
            if @user.save
              flash[:notice] = t('users.update_password.flash.notice', :default => "Your password has been updated.")
              redirect_to profile_url(@user)
            else
              render 'edit_password'
            end
          end
        else
          flash[:error] = t('users.update_password.flash.error.confirmation_does_not_match', :default => "Your new password and it's confirmation don't match.")
          redirect_to edit_password_user_url(@user)
        end
      else
        flash[:error] = t('users.update_password.flash.error.current_password_invalid', :default => "Your current password is not correct. Your password has not been updated.")
        redirect_to edit_password_user_url(@user)
      end
    else
      flash[:error] = t('users.update_password.flash.error.another_user_password', :default => "You cannot update another user's password!")
      redirect_to edit_password_user_url(@user)
    end
  end

  def edit_email
    # render edit_email.html.erb
  end

  def update_email
    if current_user == @user
      if @user.update_attributes(:email => params[:email])
        flash[:notice] = t('users.update_email.flash.notice', :default => "Your email address has been updated.")
        redirect_to profile_url(@user)
      else
        flash[:error] = t('users.update_email.flash.error.not_updated', :default => "Your email address could not be updated.")
        redirect_to edit_email_user_url(@user)
      end
    else
      flash[:error] = t('users.update_email.flash.error.another_user_email', :default => "You cannot update another user's email address!")
      redirect_to edit_email_user_url(@user)
    end
  end

  def destroy
    current_user.delete!
    current_user_session.destroy
    flash[:notice] = t('users.destroy.flash.notice', :default => "Your account has been removed.")
    redirect_back_or_default(root_path)
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end

  def create_new_user(attributes)
    @user = User.new(attributes)
    if @user && @user.valid?
      @user.register!
    end

    if @user.errors.empty?
      successful_creation(@user)
    else
      failed_creation
    end
  end

  def successful_creation(user)
    redirect_back_or_default(root_path)
    flash[:notice] = t('users.successful_creation.flash.notice',
                    :default => "Thanks for signing up! We're sending you an email with your activation code.")
  end

  def failed_creation(message = t('users.failed_creation.flash.error', :default => 'Sorry, there was an error creating your account'))
    flash[:error] = message
    # @user = User.new
    render :action => :new
  end
end

