class PeopleController < InheritedResources::Base
  layout "dashboard"
  
  private
  def collection
    @people = end_of_association_chain.students
  end
end
