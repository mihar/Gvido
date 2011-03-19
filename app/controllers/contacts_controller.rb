class ContactsController < InheritedResources::Base
  load_and_authorize_resource
  skip_load_resource :only => [:new_report]
  skip_before_filter :authenticate_user!, :only => [:new, :create, :new_report]
  before_filter :set_section

  # Different layouts here.
  layout :pick_layout

  def create
    params[:contact][:instrument_ids] ||= []
    params[:contact][:location_ids] ||= []
    create! { new_report_contacts_path }
  end
  
  def destroy
    destroy! { dashboard_path}
  end
    
  private

  def pick_layout
    [:new, :create, :new_report].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def set_section
    @section = :contact
  end
end
