class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper

  def administrator_access
    unless authorized?("Administrator")
      store_location
      flash[:danger] = "Unauthorized action"
      redirect_to login_url
    end
  end

  def controller_access
    unless authorized?("Controller")
      store_location
      flash[:danger] = "Unauthorized action"
      redirect_to login_url
    end
  end

  def admin?
    authorized?("Administrator")
  end

end
