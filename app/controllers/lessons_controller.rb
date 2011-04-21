class LessonsController < ApplicationController
  before_filter :restrict_access
  load_and_authorize_resource
  
  layout 'dashboard'
  
  #displays lessons for students that need to pay this month
  def index
    @lessons = Array.new
    lessons = Array.new
    date = Date.today == Date.today.at_end_of_month ? Date.today : Date.today.prev_month.at_end_of_month
    
    Lesson.where(:check_in_date => date, :mentor_id => current_user.mentor.id).each do |lesson|
      @lessons << {
        :student => lesson.payment.enrollment.student.full_name,
        :lesson => lesson
      }
      lessons << lesson
    end
    
    if Date.today == Date.today.at_end_of_month
      @period = "od #{l Date.today.at_beginning_of_month } do #{l Date.today}"
      @editing = true
    else
      @period = "od #{l Date.today.prev_month.at_beginning_of_month } do #{l Date.today.prev_month.at_end_of_month}"
      @editing = false
    end
    @mentors_wage = lessons.map(&:hours_this_month).sum * current_user.mentor.price_per_private_lesson
  end
  
  def bulk_update
    Lesson.update(params[:lesson].keys, params[:lesson].values)
    redirect_to :lessons, :notice => 'Števila predavanj so bila uspešno posodobljena'
  end
  
  protected
  
  def restrict_access
    raise CanCan::AccessDenied unless mentor?
  end
end
