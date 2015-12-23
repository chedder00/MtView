class RolesController < ApplicationController
  def new
    @role = Role.new
    @page_heading = "Create User Role"
    @btn_text = "Create Role"
    render 'shared/form'
  end

  def create
    @role = Role.new(role_params)
    @page_heading = "Create User Role"
    @btn_text = "Create Role"
    if(@role.save)
      redirect_to new_role_path
    else
      render 'shared/form'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
    @roles = Role.all
    @page_title = "User Roles"
  end

################## PRIVATE METHODS #############################################
private
  def role_params
    params.require(:role).permit(:name, :level)
  end
end
