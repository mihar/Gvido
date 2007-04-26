# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper  
  def stylesheets(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  def javascripts(*args)
    content_for(:javascripts) do
      javascript_include_tag(*args)
    end
  end

  def body_class(klass)
    if @body_class
      @body_class += " #{klass}"
    else
      @body_class = klass
    end
  end

  def body_attrs
    @body_attrs.merge({:class => [@body_attrs[:class], @body_class].join(" ")})
  end

  def title(_title, heading = true)
    default = "Gvido"
    title = (_title) ? "#{_title} (#{default})" : default
    content_for(:title) { title }

    if heading
      return content_tag(:a, "", :name => "top") + content_tag(:h1, _title)
    end
  end

  def admin_section(klass=nil, &block)
    if admin?
      content_tag(:div, capture(&block), :class => 'admin')
    end
  end

  def home_title(_title)
    default = "Gvdio"
    title = (_title) ? _title : default
    content_for(:title) { title }

    return content_tag(:a, "", :name => "top") + content_tag(:h1, link_to(_title, root_page)) 
  end
end
