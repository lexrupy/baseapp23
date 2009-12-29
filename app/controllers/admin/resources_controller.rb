class Admin::ResourcesController < ApplicationController
  require_role :admin

  def index
    @resources = Resource.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @resource = Resource.find(params[:id])
  end

  def new
    @resource = Resource.new
  end

  def edit
    @resource = Resource.find(params[:id])
  end

  def create
    @resource = Resource.new(params[:resource])
    if @resource.save
      flash[:notice] = t('admin.resources.create.flash.notice', :default => 'Resource was successfully created.')
      redirect_to admin_resource_path(@resource)
    else
      render :action => "new"
    end
  end

  def update
    @resource = Resource.find(params[:id])
    if @resource.update_attributes(params[:resource])
      flash[:notice] = t('admin.resources.update.flash.notice', :default => 'Resource was successfully updated.')
      redirect_to admin_resource_path(@resource)
    else
      render :action => "edit"
    end
  end

  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy
    redirect_to admin_resources_url
  end
  
  # Non Restful methods
  def add_new_group
    @resource_group = ResourceGroup.find_or_create_by_name(params[:resource_group])
  end
  
end

