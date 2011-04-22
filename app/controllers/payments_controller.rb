class PaymentsController < ApplicationController
  load_and_authorize_resource
  layout "dashboard"
  before_filter :set_section
  
  def index
    @payable_dates = Payment.all_payment_dates
    unless params[:payable_date].blank?
      @selected_date = Date.new(  params[:payable_date][0..3].to_i, 
                                  params[:payable_date][5..6].to_i, 
                                  params[:payable_date][8..9].to_i )
      @payments = Payment.on_date(@selected_date)
      set_instance_vars
      return
    end
    
    @selected_date = Date.today.at_beginning_of_month + Enrollment::DATE_SPACER
    @payments = Payment.on_date(@selected_date)
    
    set_instance_vars
  end
  
  def settle
    settle_it(params[:id])
  end
  
  def unsettle
    settle_it(params[:id], false)
  end
  
  def show
    @payment = Payment.find(params[:id])
    @student    = if @payment.enrollment and @payment.enrollment.student then @payment.enrollment.student else nil end
    @exception  = if @payment.payment_exception then @payment.payment_exception else nil end
  end
  
  private
  
  def settle_it(id, settled = true)
    payment = Payment.find(id)
    payment.settled = settled
    payment.save
    redirect_to payments_path(:payable_month => payment.payment_date.to_s)
  end
  
  def set_instance_vars
    @expected_payments_sum  = @payments.map(&:calculated_price).sum
    @settled_payments_sum   = @payments.settled(true).map(&:calculated_price).sum
    @unsettled_payments_sum = @payments.unsettled(true).map(&:calculated_price).sum
  end
  
  def set_section
    @section = :payments
  end
end
