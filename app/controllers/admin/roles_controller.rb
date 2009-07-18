class Admin::RolesController < ApplicationController
  require_role :admin

  def index
    @roles = Role.paginate(:page => params[:page], :per_page => 10)
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    # Normalize params if they're empty
    params[:role] ||= {}
    params[:role][:resource_ids] ||= []
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      flash[:notice] = t('admin.roles.update.flash.notice', :default => 'Role was successfully updated.')
      redirect_to admin_roles_path
    else
      render :action => "edit"
    end
  end

end

