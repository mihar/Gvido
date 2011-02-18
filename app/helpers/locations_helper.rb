module LocationsHelper
  def location_html(l)
    html = []
    html << content_tag(:h3, "GVIDO - #{l.title} - #{l.city}")
    html << content_tag(:p, "#{l.address}, #{l.zip}, #{l.city}")
    content_tag :div, html.join, :style => "width: 250px;"
  end
  
  def location_tooltip(l)
    l.title
  end
end
