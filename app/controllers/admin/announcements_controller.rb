class Admin::AnnouncementsController < ApplicationController
  require_role :admin

  def index
    @announcements = Admin::Announcement.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @announcement = Admin::Announcement.find(params[:id])
  end

  def new
    @announcement = Admin::Announcement.new
  end

  def edit
    @announcement = Admin::Announcement.find(params[:id])
  end

  def create
    @announcement = Admin::Announcement.new(params[:admin_announcement])
    if @announcement.save
      flash[:notice] = t('admin.announcements.create.flash.notice', :default => 'Announcement was successfully created.')
      redirect_to @announcement
    else
      render :action => "new"
    end
  end

  def update
    @announcement = Admin::Announcement.find(params[:id])
    if @announcement.update_attributes(params[:admin_announcement])
      flash[:notice] = t('admin.announcements.update.flash.notice', :default => 'Announcement was successfully updated.')
      redirect_to @announcement
    else
      render :action => "edit"
    end
  end

  def destroy
    @announcement = Admin::Announcement.find(params[:id])
    @announcement.destroy
    redirect_to admin_announcements_url
  end
end

