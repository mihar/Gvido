class DashboardController < ApplicationController
  before_filter :restrict_access
  skip_authorization_check
  
  def index
    if mentor?
      redirect_to :lessons
      return
    end
    @contacts = Contact.unprocessed
  end
  
  protected
  
  def restrict_access
    raise CanCan::AccessDenied unless admin? or mentor?
  end
end
