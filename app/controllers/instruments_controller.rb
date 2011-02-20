class InstrumentsController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
  
  protected
  
  def resource
    @instrument ||= end_of_association_chain.find_by_permalink params[:id]
  end
  
  def set_section
    @section = :instruments
  end
end
