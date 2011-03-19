class PaymentsController < ApplicationController
  load_and_authorize_resource
  layout "dashboard"
  before_filter :set_section
  
  def index
    @payable_months = Payment.all_payment_dates
    unless params[:payable_month].blank?
      @payments = Payment.monthly_payments(params[:payable_month])
      return
    end
    @payments = Payment.monthly_payments(Date.today.at_beginning_of_month)
  end
  
  def settle
    settle_it(params[:id])
  end
  
  def unsettle
    settle_it(params[:id], false)
  end
  
  def show
    @payment = Payment.find(params[:id])
    @enrollment = if @payment.enrollment then @payment.enrollment else nil end
    @student    = if @enrollment.student then @enrollment.student else nil end
    @exception  = if @payment.payment_exception then @payment.payment_exception else nil end
  end
  
  private
  
  def settle_it(id, settled = true)
    payment = Payment.find(id)
    payment.settled = settled
    payment.save
    redirect_to payments_path(:payable_month => payment.payment_date.to_s)
  end
  
  def set_section
    @section = :payments
  end
end
