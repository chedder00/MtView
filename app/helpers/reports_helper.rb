module ReportsHelper
  def pdf_link(params)
    p = params["#{@grid.class.to_s.underscore}"]
    link = "#{@grid.class.to_s.underscore}.pdf?utf8="
    p.each do |k, v|
      link +="&#{@grid.class.to_s.underscore}%5B#{k}%5D=#{v}"
    end
    link
  end
end
