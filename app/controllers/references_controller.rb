class ReferencesController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
   
  def create
    create! { references_path }
  end
  
  def update
    update! { references_path }
  end
  
  private
  
  def set_section
    @section = :references
  end
end
