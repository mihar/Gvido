class ApplicationController < ActionController::Base
  #before_filter :set_locale
  helper :all # include all helpers, all the time
  helper_method :current_section, :admin?, :body_attrs
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
  
  # Set Slovenian locale
  def set_locale
    I18n.locale = "sl"
  end
  
  # Current section accessor.
  def current_section
    @section
  end
  
  # Admin status determinator
  def admin?
  	#session[:passphrase] == current_password
  	true
  end
  
  # Verify administrator status, otherwise save current path for returning and redirect to login page.
  def authenticate
    if not admin?
      flash[:notice] = "Prosimo prijavite se z ustreznim geslom."
      session[:return_path] = request.env["REQUEST_URI"] || '/'
      redirect_to new_session_path
    end
  end

  def current_password
    "roland2000"
  end
  
  def body_attrs
    { :class => controller_name, :id => "#{controller_name}-#{action_name}" }
  end
end
