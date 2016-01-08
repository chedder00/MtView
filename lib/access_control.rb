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

  def reseller?
    @lvl ||= Role.find_by(name: "Reseller").level
    @lvl == current_user.role.level
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

  #Returns true is user level is greater than or equal to administration level
  def authorized?(key)
    admin_lvl = access(key)
    if(!current_user.nil?)
      user_lvl = current_user.role.level
    else
      user_lvl = -1
    end
  
    user_lvl >= admin_lvl
  end

  def access(key)
    case key
      when "Controller"
        @ctr ||= Role.find_by(name: key)
        ret_val = @ctr.level
      when "Administrator"
        @adm ||= Role.find_by(name: key)
        ret_val = @adm.level
      when "Inventory Controller"
        @ictr ||= Role.find_by(name: key)
        ret_val = @ictr.level
      when "Regular Employee"
        @reg  ||= Role.find_by(name: key)
        ret_val = @reg.level
    end
    return ret_val
  end

end