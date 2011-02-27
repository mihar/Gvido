class LinkCategoriesController < InheritedResources::Base
  before_filter :set_section
  layout :pick_layout
  
  def create
    create! { all_link_categories_path }
  end
  
  def update
    update! { all_link_categories_path }
  end
  
  def destroy
    destroy! { all_link_categories_path }
  end
  
  private
  
  def pick_layout
    [:index].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def collection
    @link_categories ||= end_of_association_chain.order("position")
  end
  
  def set_section
    @section = :links
  end
end
