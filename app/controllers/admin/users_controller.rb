class Admin::UsersController < ApplicationController
  require_role :admin
  
  before_filter :load_user, :except => [:index, :create, :new]
  
  def load_user
    @user = User.find(params[:id])
  end
  
  def index 
    conditions = {:state => params[:state]} unless params[:state].blank?
    @users = User.paginate :all, :conditions => conditions, :page => params[:page]
  end
  
  def activate
    @user.activate!
    redirect_to admin_users_path
  end

  def suspend
    @user.suspend!
    redirect_to admin_users_path
  end

  def unsuspend
    @user.unsuspend!
    redirect_to admin_users_path
  end

  def purge
    @user.destroy
    redirect_to admin_users_url
  end

  def destroy
    @user.delete!
    redirect_to admin_users_path
  end
  
  def reset_password
    @user.reset_password!
    flash[:notice] = t('admin.users.reset_password.flash.notice', :default => "A new password has been sent to the user by email.")
    redirect_to admin_user_path(@user)
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
    @user.role_ids = params[:user][:role_ids]
    @user.resource_ids = params[:user][:resource_ids]
    if @user.save
      flash[:notice] = t('admin.users.update.flash.notice', :default => "User was successfully updated.")
      redirect_to admin_user_url(@user)
    else
      render :action => "edit"
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.register!
      flash[:notice] = t('admin.users.create.flash.notice', :default => "User was successfully created.")
      redirect_to admin_user_url(@user)
    else
      render :action => "new"
    end
  end
  
end

