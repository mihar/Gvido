class PersonalContactsController < InheritedResources::Base
  belongs_to :student
  load_and_authorize_resource
  layout "dashboard"
  
  def create
    create! { student_path(parent) }
  end
  
  def update
    update! { student_path(parent) }
  end
  
  def destroy
    destroy! { student_path(parent) }
  end
end
