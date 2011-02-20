class ContactsController < InheritedResources::Base
  before_filter :set_section
  respond_to :html

  def create
    params[:contact][:instrument_ids] ||= []
    params[:contact][:location_ids] ||= []
    create! { new_report_contacts_path }
  end
    
  private
  
  def set_section
    @section = :contact
  end
end
