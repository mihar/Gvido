class LinksController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
  
  def index
    @links = LinkCategory.includes(:links)
    super
  end
  
  protected
  
  def set_section
    @section = :links
  end
end
