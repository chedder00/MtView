module TasksHelper

  def staff_users
    @staff ||= User.staff
  end
  
end
