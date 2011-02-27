class PeopleController < InheritedResources::Base
  layout "dashboard"
  before_filter :set_section
  
  def new
    @person = Person.new
    
    # If no contact ID given, we can skip this step.
    return unless params[:contact_id]
    contact = Contact.find params[:contact_id]
    @person.first_name = contact.name
    @person.email = contact.email
    @person.address = contact.address
    @person.mobile = contact.phone
  end
  
  private
  def set_section
    @section = :people
  end

  def collection
    @people = end_of_association_chain.students
  end
end
