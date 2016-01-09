class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  before_action :validate_session

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in"
      redirect_back_or login_url
    end
  end

  def method_missing(method, *args, &block)
    return false if current_user.nil?
    self.class.send :define_method, method do |arg=nil|
      unless current_user.send(method, *args, &block)
        flash[:danger] = "Unauthorized Access"
        return false
      end
      return true
    end
    self.send(method)
  end

private
  def validate_session
    if(!session[:expires_at].nil? && session[:expires_at] >= Time.current)
      session[:expires_at] = Time.current + 10.minutes
    else
      logout
    end
  end

end
