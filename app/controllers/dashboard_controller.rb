class DashboardController < ApplicationController
  before_filter :restrict_access
  skip_authorization_check
  
  def index
    @contacts = Contact.unprocessed
  end
  
  protected
  
  def restrict_access
    raise CanCan::AccessDenied unless admin?
  end
end
