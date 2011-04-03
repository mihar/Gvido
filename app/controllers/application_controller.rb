class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_section, :admin?, :mentor?, :body_attrs
  before_filter :authenticate_user!, :except => [:index, :show]
  protect_from_forgery
  
  
  # Cancan
  check_authorization
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to user_session_path, :error => exception.message
  end

  
  protected
  
  # Current section accessor.
  def current_section
    @section
  end
  
  def admin?
    current_user and current_user.admin?
  end
  
  def mentor?
    current_user and current_user.mentor?
  end
  
  def body_attrs
    { :class => controller_name, :id => "#{controller_name}-#{action_name}" }
  end
end
