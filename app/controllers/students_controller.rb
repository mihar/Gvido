class StudentsController < InheritedResources::Base
  load_and_authorize_resource
  layout "dashboard"
  before_filter :set_section
  
  def new
    @student = Student.new
    # If no contact ID given, we can skip this step.
    return unless params[:contact_id]
    contact = Contact.find params[:contact_id]
    @student.first_name = contact.name
    @student.email = contact.email
    @student.address = contact.address
    @student.mobile = contact.phone
  end
  
  private
  def set_section
    @section = :people
  end
end
