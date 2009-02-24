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
      flash[:notice] = 'Resource was successfully created.'
      redirect_to admin_resource_path(@resource)
    else
      render :action => "new"
    end
  end

  def update
    @resource = Resource.find(params[:id])
    if @resource.update_attributes(params[:resource])
      flash[:notice] = 'Resource was successfully updated.'
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
end
