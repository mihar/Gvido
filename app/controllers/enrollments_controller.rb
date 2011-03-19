class EnrollmentsController < InheritedResources::Base
  load_and_authorize_resource
  belongs_to :student
  
  layout 'dashboard'
  
  def create
    student = Student.find params[:student_id]
    student.status = Status.find 3 #Vpisan
    student.save
    create! { student_path(parent) }
  end
  
  def update
    update! { student_path(parent) }
  end
    
  def destroy
    student = Student.find params[:student_id]
    if student.enrollments.length.eql?(1)
      student.status = Status.find 4 #Izbrisan
      student.save
    end
    destroy! { student_path(parent) }
  end
  

end
