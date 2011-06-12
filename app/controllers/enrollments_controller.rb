class EnrollmentsController < InheritedResources::Base
  load_and_authorize_resource
  belongs_to :student
  
  layout 'dashboard'
  
  def create
    student = Student.find params[:student_id]
    student.status = Status.find 3 #Vpisan
    student.save
    
    @enrollment = Enrollment.new(params[:enrollment])
    @enrollment.student = student
    
    if @enrollment.save
      redirect_to(new_enrollment_payment_period_url(@enrollment),
                  :notice => 'Uspešno ste vpisali učenca, sedaj izpolnite plačniška obdobja')
    else
      render :new
    end
  end
  
  def update
    previous_enrollment = Enrollment.find(params[:id])
    previous_cancel_date = previous_enrollment.cancel_date
    new_cancel_date = Date.new(params[:enrollment][:"cancel_date(1i)"].to_i,params[:enrollment][:"cancel_date(2i)"].to_i,params[:enrollment][:"cancel_date(3i)"].to_i)

    if previous_cancel_date != new_cancel_date
      update!(:notice => "Uspešno ste spremenili dolžino vpisnine, sedaj morate morate uredi zadnje plačilno obdobje v vpisnini") { edit_enrollment_payment_period_url( previous_enrollment.id, PaymentPeriod.last_for_enrollment(params[:id]) ) }
    else
      update! { student_path(parent) }
    end
  end
  
  def mentor_instruments
    respond_to { |wants| wants.js }
  end
  
  def destroy
    student = Student.find params[:student_id]
    if student.enrollments.length.eql?(1)
      student.status = Status.find 4 #Izbrisan
      student.save
    end
    
    enrollment = Enrollment.find params[:id]
    enrollment.destroy if enrollment 
    
    redirect_to student_path(parent)
  end

end
