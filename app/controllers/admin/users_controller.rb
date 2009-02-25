class Admin::UsersController < ApplicationController
  require_role :admin

  def reset_password
    @user = User.find(params[:id])
    @user.reset_password!
    flash[:notice] = "A new password has been sent to the user by email."
    redirect_to admin_user_path(@user)
  end

  def pending
    @users = User.paginate :all, :conditions => {:state => 'pending'}, :page => params[:page]
    render :action => 'index'
  end

  def suspended
    @users = User.paginate :all, :conditions => {:state => 'suspended'}, :page => params[:page]
    render :action => 'index'
  end

  def active
    @users = User.paginate :all, :conditions => {:state => 'active'}, :page => params[:page]
    render :action => 'index'
  end

  def deleted
    @users = User.paginate :all, :conditions => {:state => 'deleted'}, :page => params[:page]
    render :action => 'index'
  end

  def activate
    @user = User.find(params[:id])
    @user.activate!
    redirect_to admin_users_path
  end

  def suspend
    @user = User.find(params[:id])
    @user.suspend!
    redirect_to admin_users_path
  end

  def unsuspend
    @user = User.find(params[:id])
    @user.unsuspend!
    redirect_to admin_users_path
  end

  def purge
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_url
  end

  def destroy
    @user = User.find(params[:id])
    @user.delete!
    redirect_to admin_users_path
  end

  def index
    @users = User.paginate :all, :page => params[:page]
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.role_ids = params[:user][:role_ids]
    @user.resource_ids = params[:user][:resource_ids]
    if @user.save
      flash[:notice] = "User was successfully updated."
      redirect_to admin_user_url(@user)
    else
      render :action => "edit"
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.register!
      flash[:notice] = "User was successfully created."
      redirect_to admin_user_url(@user)
    else
      render :action => "new"
    end
  end
end
