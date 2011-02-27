class ReferencesController < InheritedResources::Base
  before_filter :set_section
  layout :pick_layout
   
  def create
    create! { all_references_path }
  end
  
  def update
    update! { all_references_path }
  end
  
  def destroy
    destroy! { all_references_path }
  end
  
  private
  
  def pick_layout
    [:index].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def set_section
    @section = :references
  end
end
