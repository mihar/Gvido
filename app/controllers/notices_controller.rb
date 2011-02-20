class NoticesController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
    
  def index
    @all = !params[:all].blank?
    index!  
  end
  
  def collection
    @notices ||= (!params[:all].blank?) ? end_of_association_chain.all : end_of_association_chain.non_expired
  end
  
  private
  
  def set_section
    @section = :abouts
  end
end
