class InstrumentsController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
  
  protected
  
  def current_object
    @current_object ||= Instrument.find_by_permalink params[:id]
  end
  
  def set_section
    @section = :instruments
  end
end
