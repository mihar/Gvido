class StudentsController < InheritedResources::Base
  load_and_authorize_resource
  layout "dashboard"
  before_filter :set_section
  
  def index
    @active_students = Student.active_students
    @future_students = Student.future_students
    @past_students = Student.past_students
    @students_with_no_enrollments = Student.with_no_enrollments
    @active_enrollments = Enrollment.active
    index!
  end
  
  def new
    @student = Student.new
    # If no contact ID given, we can skip this step.
    return unless params[:contact_id]
    contact = Contact.find params[:contact_id]
    @student.first_name = contact.name
    @student.email = contact.email
    @student.address = contact.address
    @student.mobile = contact.phone
    @student.contact_id = contact.id
  end
  
  private
  def set_section
    @section = :students
  end
end
