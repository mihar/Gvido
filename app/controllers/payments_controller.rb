class PaymentsController < ApplicationController
  load_and_authorize_resource
  layout "dashboard"
  
  def index
    @payable_months = Payment.all_payment_dates
    unless params[:payable_month].blank?
      @payments = Payment.monthly_payments(params[:payable_month])
      return
    end
    @payments = Payment.monthly_payments(Date.today.at_beginning_of_month)
  end
  
end
