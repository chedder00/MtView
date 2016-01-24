module ApplicationHelper

  #Establishes full page title for each page rendered
  def full_title(page_title = '')
    site_title = t('company.title')
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
    return current_user.send(method, *args, &block)
  end

  def asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end

end
