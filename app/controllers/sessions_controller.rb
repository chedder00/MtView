class SessionsController < ApplicationController
  
  skip_before_action :validate_session, only: [:new, :create]

  def new
    @page_title = "Login"
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if(user && user.authenticate(params[:session][:password]))
      if( !user.activated? )
        flash[:danger] = "Account currently inactive"
        session.delete(:user_id)
      else  
        login(user)
      end
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
