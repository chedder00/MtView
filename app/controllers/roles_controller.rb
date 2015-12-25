class RolesController < ApplicationController
  
  before_action :administrator_access

  def new
    @role = Role.new
    @page_title = "Add Role"
    @page_heading = "Create User Role"
    @btn_text = "Create Role"
    render 'shared/form'
  end

  def create
    @role = Role.new(role_params)
    @page_title = "Add Role"
    @page_heading = "Create User Role"
    @btn_text = "Create Role"
    if(@role.save)
      flash.now[:success] = "#{@role.name} role created"
      redirect_to new_role_path
    else
      render 'shared/form'
    end
  end

  def edit
    @role = Role.find(params[:id])
    @page_title = @page_heading = "Edit Role"
    @btn_text = "Update Role"
    render 'shared/form'
  end

  def update
    @role = Role.find(params[:id])
    @page_title = @page_heading = "Edit Role"
    @btn_text = "Update Role"
    if(@role.update_attributes(role_params))
      flash.now[:success] = "#{@role.name} successfully updated"
      redirect_to roles_path
    else
      render 'shared/form'
    end
  end

  def destroy
    Role.find(params[:id]).destroy
    flash[:success] = "Role deleted"
    redirect_to roles_path
  end

  def index
    @roles = Role.paginate(page: params[:page])
    @page_title = @page_heading = "User Roles"
  end

################## PRIVATE METHODS #############################################
private
  def role_params
    params.require(:role).permit(:name, :level)
  end
end
