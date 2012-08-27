class MentorsController < InheritedResources::Base
  load_and_authorize_resource
  layout :pick_layout
  
  def new
    @mentor = Mentor.new
    @mentor.build_user
    new!
  end
  
  def index
    @mentors = Mentor.all
    if params[:by_instrument]

    elsif params[:referents]
      @referents = Mentor.referents
      render :template => "mentors/referents_index"
    else
      @locations = Location.order(:title)
      @mentors_by_location = @locations.map { |l| [l, l.mentors]}
      @json = @locations.to_gmaps4rails do |location, marker|
        marker.infowindow render_to_string(:partial => 'locations/mentor_info', :locals => {:location => location})
      end
    end
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
    @check_in_dates = MonthlyLesson.check_in_dates_for_mentor(resource.id)
  end
  
  def wages
    @check_in_dates = MonthlyLesson.check_in_dates_for_mentor(resource.id)
    unless params[:check_in_date].blank?
      @selected_date = Date.new(  params[:check_in_date][0..3].to_i, 
                                  params[:check_in_date][5..6].to_i, 
                                  params[:check_in_date][8..9].to_i )
      
      get_mentors_monthly_lessons_and_set_wage
      return
    end

    @selected_date = Date.today.at_beginning_of_month
    get_mentors_monthly_lessons_and_set_wage
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
  
  def get_mentors_monthly_lessons_and_set_wage
    @monthly_lessons = MonthlyLesson.on_date_with_mentor(@selected_date, resource.id).non_public_lessons
    @monthly_lessons_public = MonthlyLesson.on_date_with_mentor(@selected_date, resource.id).public_lessons
    
    if resource.price_per_private_lesson
      @mentors_wage = @monthly_lessons.map(&:hours).sum * resource.price_per_private_lesson
    else
      flash[:error] = 'Mentorju niste vnesli cene zasebnih ur.' 
    end
  end
  
  def resource
    @mentor ||= end_of_association_chain.find_by_permalink params[:id]
  end
end
