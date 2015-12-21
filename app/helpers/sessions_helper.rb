module SessionsHelper

  #Creates a temporary session cookie with the users id active only while the 
  #browser is open
  def login(user)
    session[:user_id] = user.id
  end

  #assigns an instance variable for the current user using the temporary
  #session cookie.  The database is only hit if current user is nil otherwise
  #the current_user instance variable is returned
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  #checks to see if user is logged into the system by returning whether or not
  #the current_user variable is set
  def logged_in?
    !current_user.nil?
  end

  #logs out current user by removing session cookie user_id and setting
  #current_user variable to nill
  def logout
    session.delete(:user_id)
    @current_user = nil
  end
  
end
