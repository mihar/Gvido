class QuestionsController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
  
  protected
  
  def set_section
    @section = :abouts
  end
  
end
