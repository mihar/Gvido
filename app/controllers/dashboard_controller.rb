class DashboardController < ApplicationController
  before_filter :restrict_access
  skip_authorization_check
  
  def index
    # Mentors go haway.
    redirect_to monthly_lessons_path if mentor?
    
    # Load up dashboard stuff.
    @mentors_without_user_accounts = Mentor.without_user_accounts
    @contacts = Contact.unprocessed   
    @students_celebrating = Student.birthday_today    
    @unsettled_invoices = Invoice.unsettled_on_date(Date.today)
    @inactive_mentors = Mentor.inactive_on_date(Date.today)
  end
  
  protected
  
  def restrict_access
    raise CanCan::AccessDenied unless admin? or mentor?
  end
end
