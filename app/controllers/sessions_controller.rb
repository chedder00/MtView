class SessionsController < ApplicationController
  
  def new
    @page_title = "Login"
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if(user && user.authenticate(params[:session][:password]))
      login(user)
      redirect_back_or root_path
    else
      flash.now[:danger] = 'Invalid login information'
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_url
  end

end
