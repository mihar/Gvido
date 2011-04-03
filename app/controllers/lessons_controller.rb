class LessonsController < ApplicationController
  before_filter :restrict_access
  load_and_authorize_resource
  
  layout 'dashboard'
  
  #displays lessons for students that need to pay this month
  def index
    current_payment_date = Date.today.at_beginning_of_month + Enrollment::DATE_SPACER
    @lessons = Array.new
    
    for enrollment in current_user.mentor.enrollments
      payment = Payment.find_by_enrollment_id_and_payment_date(
        enrollment.id,
        current_payment_date)
        
      unless payment.nil?
        @lessons << {
          :student => payment.enrollment.student.full_name,
          :lesson => Lesson.find_or_create_by_student_id_and_mentor_id_and_payment_id(
            payment.enrollment.student.id,
            current_user.id,
            payment.id)
          }
      end
    end
  end
  
  def update
    Lesson.update(params[:lesson].keys, params[:lesson].values)
    redirect_to :lessons, :notice => 'Števila predavanj so bila uspešno posodobljena'
  end
  
  protected
  
  def restrict_access
    raise CanCan::AccessDenied unless mentor?
  end
end
