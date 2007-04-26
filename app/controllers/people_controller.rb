class PeopleController < InheritedResources::Base
  private
  def collection
    @people = end_of_association_chain.students
  end
end
