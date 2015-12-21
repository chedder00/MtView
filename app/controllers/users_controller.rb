class UsersController < ApplicationController
  def new
    @page_title = "New User Registration"
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if(@user.save)
      flash[:success] = "Account created for #{@user.name}"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def show
  end

  def index
  end

################## PRIVATE METHODS #############################################
private
  def user_params
    params.require(:user).permit(:name, :email, :hire_date, :address,
                                 :address2, :city, :state, :zipcode,
                                 :phone_number, :role_id, :password, 
                                 :password_confirmation)
  end

end