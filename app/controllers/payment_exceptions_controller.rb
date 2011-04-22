class PaymentExceptionsController < ApplicationController
  load_and_authorize_resource
  layout "dashboard"
  
  def new
    payment = Payment.find(params[:payment_id])
    @payment_exception = payment.build_payment_exception
    @lessons = payment.lessons(true)
  end
  
end