module SessionsHelper

  #Creates a temporary session cookie with the users id active only while the 
  #browser is open
  def login(user)
    session[:user_id] = user.id
    session[:expires_at] = Time.current + 10.minutes
  end

  #assigns an instance variable for the current user using the temporary
  #session cookie.  The database is only hit if current user is nil otherwise
  #the current_user instance variable is returned
  def current_user
    user = User.find_by(id: session[:user_id]) 
    if(user && user.activated?)
      @current_user = user
    end
  end 

  #checks to see if user is logged into the system by returning whether or not
  #the current_user variable is set
  def logged_in?
    !current_user.nil?
  end

  #logs out current user by removing session cookie user_id and setting
  #current_user variable to nill
  def logout
    reset_session
    @current_user = nil
  end

  #Returns true is user is equal to current_user
  def current_user?(user)
    user == current_user
  end
  
  #Redirects to stored location or to the default location
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  #Stores the URL try to be accessed
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

end
