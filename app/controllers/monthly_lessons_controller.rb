class MonthlyLessonsController < ApplicationController
  before_filter :restrict_access
  load_and_authorize_resource
  
  layout 'dashboard'

  def index
    date = Date.today.at_beginning_of_month.prev_month
    @all_mentors_monthly_lessons = MonthlyLesson.for_mentor_on_date(current_user.mentor.id, date).non_public_lessons
    @monthly_lessons = @all_mentors_monthly_lessons.map { |ml| { :student_name => ml.student.to_s, :programme_title => ml.enrollment.programme, :students_monthly_lessons => ml}}
    @monthly_lessons_public = current_user.mentor.monthly_lessons.public_lessons.on_date(date)
    @period = "od #{l date } do #{l date.at_end_of_month}"
    last_entry = current_user.mentor.last_hours_entry_at
    if (last_entry.nil?) or 
       ( not last_entry.nil? and (last_entry.to_date < date) and (Date.today <= date + MonthlyLesson::CHECK_IN_DATE_SPACER) )
      @can_edit = true
    else
      @can_edit = false
    end
    @students = (current_user and current_user.mentor) ? current_user.mentor.students : Student.all
    @mentors_wage = @all_mentors_monthly_lessons.map(&:hours).sum * current_user.mentor.price_per_private_lesson
  end
  
  def bulk_update
    @mentor = current_user.mentor
    if bulk_update_guts
      @mentor.last_hours_entry_at = DateTime.now
      @mentor.save
      redirect_to monthly_lessons_path, :notice => 'Števila predavanj so bila uspešno posodobljena'
    else
      render index
    end
  end
  
  def bulk_update_for_admin
    @mentor = Mentor.find_by_permalink params[:mentor_id]
    if bulk_update_guts
      @mentor.update_attribute :last_hours_entry_at, DateTime.now if @mentor
      redirect_to all_mentors_path, :notice => 'Števila predavanj so bila uspešno posodobljena'
    else #TODO fix this shit - update seems to return true no mater what
      render wages_mentor_path(@mentor.id, :check_in_date => params[:check_in_date])
    end
  end
  
  protected
  
  def bulk_update_guts
    MonthlyLesson.update_public(params[:student_public_lesson], @mentor)
    MonthlyLesson.update(params[:students_monthly_lessons].keys, params[:students_monthly_lessons].values)
  end
  
  def restrict_access
    raise CanCan::AccessDenied unless mentor? or admin?
  end
end
