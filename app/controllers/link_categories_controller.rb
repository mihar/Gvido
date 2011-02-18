class LinkCategoriesController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
  
  protected
  
  def collection
    @link_categories ||= end_of_association_chain.order("position")
  end
  
  def set_section
    @section = :links
  end
end
