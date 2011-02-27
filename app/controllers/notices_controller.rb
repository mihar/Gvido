class NoticesController < InheritedResources::Base
  load_and_authorize_resource
  before_filter :set_section
  layout :pick_layout
    
  def index
    @all = !params[:all].blank?
    index!  
  end
  
  def collection
    @notices ||= (!params[:all].blank?) ? end_of_association_chain.all : end_of_association_chain.non_expired
  end
  
  def create
    create! { all_notices_path }
  end
  
  def update
    update! { all_notices_path }
  end
  
  def destroy
    destroy! { all_notices_path }
  end
  
  private
  
  def pick_layout
    [:index, :show].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def set_section
    @section = :abouts
  end
end
