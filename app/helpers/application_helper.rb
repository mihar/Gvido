module ApplicationHelper
  def random_image
    (1..18).map { |num| "#{num}.jpg" }[rand(14)]
  end
  
  def spit(klass, field, tag = :p, textlze = false)
    content = klass.send(field)
    content = textilize(content) if textlze
    unless klass.send(field).blank? or klass.send(field).nil?
      content_tag tag.to_sym, content.html_safe, :class => field
    end
  end
  
  def spit_with_links(klass, field, attribute="title")
    tmp = klass.send(field).map { |i| link_to i.send(attribute), send("#{field.to_s.singularize}_path", i) }.join(", ")
    return tmp.to_s.html_safe
  end
  
  def spit_string_links(klass, field, link=nil)
    tmp = klass.send(field).map do |i| 
      if link.nil?
        path = send("#{field.to_s.singularize}_path", i)
      else
        path = send("#{link.to_s.singularize}_path", i)
      end
      link_to i, path 
    end.join(", ")
    return tmp.to_s.html_safe
  end
  
  def render_misc(template)
    content_tag :div, render(:partial => "misc/#{template}"), :class => "misc"
  end
  
  def date_hash_to_links(date_hash, action_string, param_key_sym)
    if date_hash and date_hash.any?
      paragraphs = []
      date_hash.each do |year, dates|
        paragraph_head = content_tag(:strong, "#{year} > ")
        paragraph_content = []
        dates.each do |date|
          date_title = l date, :format => :month
          paragraph_content << link_to(date_title, :action => action_string, param_key_sym => date.to_s)
        end
        content = paragraph_head + paragraph_content.join(", ").html_safe
        paragraphs << content_tag(:p, content)
      end
      content_tag(:div, paragraphs.to_s.html_safe, :class => "selectable-dates")
    else
      tag("div", :class => "selectable-dates")
    end
  end
end
