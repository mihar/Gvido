class ContactsController < InheritedResources::Base
  load_and_authorize_resource
  before_filter :set_section
  skip_load_resource :only => [:all, :new_report]
  respond_to :html

  # Different layouts here.
  layout :pick_layout

  def create
    params[:contact][:instrument_ids] ||= []
    params[:contact][:location_ids] ||= []
    create! { new_report_contacts_path }
  end
    
  private

  def pick_layout
    [:new, :create, :new_report].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def set_section
    @section = :contact
  end
end
