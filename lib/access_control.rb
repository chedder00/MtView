module AccessControl
  
  include SessionsHelper

  def controller?
    authorized?("Controller")
  end

  def admin?
    authorized?("Administrator")
  end

  def inventory_controller?
    authorized?("Inventory Controller")
  end

  def staff?
    authorized?("Regular Employee")
  end

  def controller_access
    unless controller?
      store_location
      flash[:danger] = "Unauthorized action"
      redirect_to login_url
    end
  end

  def administrator_access
    unless admin?
      store_location
      flash[:danger] = "Unauthorized action"
      redirect_to login_url
    end
  end

  def inventory_controller_access
    unless inventory_controller?
      store_location
      flash[:danger] = "Unauthorized action"
      redirect_to login_url
    end
  end

  def staff_access
    unless staff?
      flash[:danger] = "Not authorized to view this page"
      redirect_back_or root_url
    end
  end

end