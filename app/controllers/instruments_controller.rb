class InstrumentsController < InheritedResources::Base
  before_filter :set_section
  
  layout :pick_layout
  
  def update
    update! { all_instruments_path }
  end
  
  def create
    create! { all_instruments_path }
  end
  
  def destroy
    destroy! { all_instruments_path }
  end
  
  protected
  
  def resource
    @instrument ||= end_of_association_chain.find_by_permalink params[:id]
  end
  
  def pick_layout
    [:index, :show].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def set_section
    @section = :instruments
  end
end
