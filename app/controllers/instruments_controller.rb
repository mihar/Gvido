class InstrumentsController < InheritedResources::Base
  load_and_authorize_resource
  before_filter :set_section
  
  layout :pick_layout
  
  def index
    @instruments = @instruments.order(:position)
  end

  def update
    update! { all_instruments_path }
  end
  
  def create
    create! { all_instruments_path }
  end
  
  def destroy
    destroy! { all_instruments_path }
  end
  
  def detail
    @active_enrollments = Enrollment.active.reject {|enrollment| enrollment.instrument != resource}.flatten.uniq
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
