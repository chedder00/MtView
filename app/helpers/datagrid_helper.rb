module DatagridHelper
  
  def form_field(form, filter, var)
    if(filter.type == :date )
      form.date_field(filter.name, var)
    else
      form.text_field(filter.name, var)
    end
  end

end
