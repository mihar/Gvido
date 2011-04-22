class DashboardController < ApplicationController
  before_filter :restrict_access
  skip_authorization_check
  
  def index
    # Mentors go haway.
    redirect_to :lessons if mentor?
    
    # Load up dashboard stuff.
    @contacts = Contact.unprocessed(true)
    @payments = Payment.due.unsettled
    @students_celebrating = Student.birthday_today
  end
  
  protected
  
  def restrict_access
    raise CanCan::AccessDenied unless admin? or mentor?
  end
end
