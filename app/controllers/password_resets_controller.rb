class PasswordResetsController < ApplicationController
  
  skip_before_action :logged_in_user
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
    @page_title = "Password Reset"
  end

  def create
    @page_title = "Password Reset"
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if(@user)
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
    @page_title = "Reset Password"
  end

  def update
    @page_title = "Reset Password"
    if(params[:user][:password].empty?)
      @user.errors.add(:password, "cannot be blank")
      render 'edit'
    elsif @user.update_attributes(user_params)
      login @user
      flash[:success] = "Password has been reset"
      redirect_to root_url
    else
      render 'edit'
    end
      
  end

################## PRIVATE METHODS #############################################
private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless(@user && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  def check_expiration
    if(@user.password_reset_expired?)
      flash[:danger] = "Password reset has expired"
      redirect_to new_password_reset_url
    end    
  end
  
end
