module ApplicationHelper
  def menu_item(caption, obj=nil, action=nil)
    param = {}
    unless obj
      link = link_to caption, '#'
    else
      route = "#{obj}_path"
      route = "#{action}_#{route}" if action
      param = {:id => "current"} if current_section == obj
      link = link_to(caption, send(route))
    end
    content_tag :li, link, param
  end
  
  def random_image
    (1..18).map { |num| "#{num}.jpg" }[rand(14)]
  end
  
  def display_flash(*indexes)
    output = ""
    indexes.each do |idx|
      if flash[idx]
        output += content_tag :span, flash[idx], :id => idx.to_s
      end
    end
    output
  end
  
  def link_to_lightbox(string, image, album = 'album', title = '')
  	ret = "<a href='#{image}' rel='lightbox[#{album}]'"
  	ret += " title='#{title}'" unless title.blank?
  	ret += "class='lightbox'>#{string}</a>"
  end
  
  def admin_section(&block)
    if admin?
      concat content_tag(:div, capture(&block), :class => 'admin')
    end
  end
  
  def spit(klass, field, tag = :p, textlze = false)
    content = h(klass.send(field))
    content = textilize(content) if textlze
    unless klass.send(field).blank? or klass.send(field).nil?
      content_tag tag.to_sym, content, :class => field
    end
  end
  
  def spit_with_links(klass, field, attribute="title")
    klass.send(field).map { |i| link_to i.send(attribute), send("#{field.to_s.singularize}_path", i) }.join(", ")
  end
  
  def spit_string_links(klass, field, link=nil)
    klass.send(field).map do |i| 
      if link.nil?
        path = send("#{field.to_s.singularize}_path", i)
      else
        path = send("#{link.to_s.singularize}_path", i)
      end
      link_to i, path 
    end.join(", ")
  end
  
  def render_misc(template)
    content_tag :div, render(:partial => "misc/#{template}"), :class => "misc"
  end
end
