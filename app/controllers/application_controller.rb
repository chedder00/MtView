class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  responders :flash

  include SessionsHelper

  before_action :validate_session
  before_action :logged_in_user

  def method_missing(method, *args, &block)
    return false if current_user.nil?    
    if(current_user.send(method, *args, &block))
      self.class.send :define_method, method do |arg=nil|
        return current_user.send(method, *args, &block)
      end
      self.send(method)
    else
      flash[:danger] = "Unauthorized Access"
      redirect_to root_url
    end    
  end

private
  def validate_session
    if(!session[:expires_at].nil? && session[:expires_at] >= Time.current)
      session[:expires_at] = Time.current + 10.minutes
    elsif(!Rails.env.development?)
      flash[:danger] = "Session Timout: "
      logout
    end
  end

  def logged_in_user
    unless logged_in?
        msg = "Please log in"
        flash[:danger] = (flash[:danger].nil?)? msg : (flash[:danger] + msg)
      redirect_back_or login_url
    end
  end

end
