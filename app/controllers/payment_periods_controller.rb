class PaymentPeriodsController < InheritedResources::Base
  load_and_authorize_resource

  belongs_to :enrollment
  
  layout 'dashboard'
  
  def new
    init_instance_vars
  end
  
  def edit
    init_instance_vars  
    edit!
  end

  def create
    save_and_redirect_properly
  end
  
  def update
    save_and_redirect_properly(true)
  end
  
  private
  
  def save_and_redirect_properly(updating = false)
    end_date = Date.new(params[:payment_period]["end_date(1i)"].to_i, params[:payment_period]["end_date(2i)"].to_i, params[:payment_period]["end_date(3i)"].to_i)
    if end_date != parent.cancel_date
      if updating
        update! {new_enrollment_payment_period_url(parent)}
      else
        create! {new_enrollment_payment_period_url(parent)}
      end
    else
      if updating
        update! {student_url(parent.student)}
      else
        create! {student_url(parent.student)}
      end
    end
  end
  
  def init_instance_vars
    default_start_date = parent.payment_periods(true).empty? ? parent.enrollment_date : parent.payment_periods(true).order('end_date ASC').last.end_date

    @payment_period = PaymentPeriod.new(:enrollment_id => parent.id, :start_date => default_start_date, :end_date => parent.cancel_date)
    if parent.price_per_lesson > 0
      @payment_plans = PaymentPlan.all.reject {|payment_plan| payment_plan.id != :per_hour}
    else
      @payment_plans = PaymentPlan.all.reject {|payment_plan| payment_plan.id == :per_hour}
      # TODO write trimester and singular exceptions
    end
  end
  
end
