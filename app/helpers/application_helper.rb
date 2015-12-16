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
end
