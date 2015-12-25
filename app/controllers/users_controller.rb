class UsersController < ApplicationController

  #Ensures all pages are only accessed by administrator or higher users
  #method can be found in application controller
  before_action :administrator_access, except: [:edit, :update]

  #Ensure only logged in users can modify profile
  before_action :logged_in_user, only: [:edit, :update]

  #Ensure that non admin users can only edit thier own password
  before_action :correct_user, only: [:edit, :update]

  def new
    @page_title = "New User Registration"
    @user = User.new
    @btn_text = "Create User"
    @page_heading = "New Users Form"
    render 'shared/form'
  end

  def create
    @page_title = "New User Registration"
    @user = User.new(user_params)
    @btn_text = "Create User"
    @page_heading = "New Users Form"
    @user.password = @user.password_confirmation = "Password1"
    if(@user.save)
      flash[:success] = "Account created for #{@user.name}"
      redirect_to root_path
    else
      render 'shared/form'
    end
  end

  def edit
    @user = User.find(params[:id])
    @page_title = "Edit User"
    @btn_text = "Update User"
    @page_heading = "Edit User #{@user.name}"
    render 'shared/form'
  end

  def update
    @user = User.find(params[:id])
    @page_title = "Edit User"
    @btn_text = "Update user"
    @page_heading = "Edit User #{@user.name}"
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to root_path
    else
      render 'shared/form'
    end
  end

  def destroy 
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to root_url
  end

  def index
    @page_title = "All Users"
    @users = User.paginate(page: params[:page])
  end

################## PRIVATE METHODS #############################################
private
  def user_params
    if(admin?)
      params.require(:user).permit( 
        :name, 
        :email, 
        :hire_date,
        :temination_date,
        :activated, 
        :address,
        :address2, 
        :city, 
        :state, 
        :zipcode,
        :phone_number, 
        :role_id, 
        :password,
        :password_confirmation
      )
    else
      params.require(:user).permit(:password, :password_confirmation)
    end
  end

  def correct_user
    unless admin?
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
  end

end