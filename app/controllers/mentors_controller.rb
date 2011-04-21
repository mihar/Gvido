class MentorsController < InheritedResources::Base
  load_and_authorize_resource
  layout :pick_layout
  
  def new
    @mentor = Mentor.new
    @mentor.build_user
    new!
  end
  
  def edit
    @mentor = Mentor.find_by_permalink params[:id]
    @mentor.build_user unless @mentor.user
    @instruments = Instrument.all.reject { |i| resource.instruments.include?(i) }
    edit!
  end
  
  def update_positions
    params[:mentors].each_with_index do |id, position|
      Mentor.update(id, :position => position)
    end
    render :nothing => true
  end
  
  def details
    @enrollments = resource.enrollments
  end
  
  def create
    create! { all_mentors_path }
  end
  
  def update
    resource.instrument_ids = [] unless params[:instrument_ids]
    resource.location_ids = [] unless params[:location_ids]
    
    update! { all_mentors_path }
  end
  
  def destroy
    destroy! { all_mentors_path }
  end
  
  private
  
  def pick_layout
    if [:index, :show].include?(action_name.to_sym)
      @section = :abouts
      "application"
    else
      @section = :mentors
      "dashboard"
    end
  end
  
  protected
  
  def resource
    @mentor ||= end_of_association_chain.find_by_permalink params[:id]
  end
end
