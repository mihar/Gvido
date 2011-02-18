class NoticesController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
  
  def set_section
    @section = :abouts
  end
  
  def index
    @all = !params[:all].blank?
    super  
  end
  
  def collection
    @notices ||= (!params[:all].blank?) ? end_of_association_chain.all : end_of_association_chain.non_expired
  end
end
