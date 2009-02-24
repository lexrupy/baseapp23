class SessionsController < ApplicationController
  layout 'login'

  skip_before_filter :authorize_user, :only => [:new, :create]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(:login => params[:login], :password => params[:password])
    if @user_session.save
      redirect_back_or_default(root_url)
    else
      render :action => :new
      logger.warn "LOGIN FAILED: for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to new_session_url
  end

end
