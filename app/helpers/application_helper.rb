module ApplicationHelper

  #Establishes full page title for each page rendered
  def full_title(page_title = '')
    site_title = "Mountain View Medicals"
    if page_title.empty?
      site_title
    else
      page_title + " | " + site_title
    end
  end


  # Mainly used to simplify new and edit forms since they are basically the same
  # except for the controller used to render the page.  This function uses the
  # calling controller to generate form string to render.
  
  def get_form
    "#{controller.controller_name}/form"
  end

  def method_missing(method, *args, &block)
    return false if current_user.nil?
    self.class.send :define_method, method do |arg=nil|
      return current_user.send(method, *args, &block)
    end
    self.send(method)
  end

end
