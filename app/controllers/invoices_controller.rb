class InvoicesController < ApplicationController
  load_and_authorize_resource
  before_filter :set_section
  layout 'dashboard'
  
  def index
    @payable_dates = Enrollment.payment_dates_up_to_date(Date.today)
    if params[:payable_date].blank?
      @selected_date = Date.today.at_beginning_of_month + Payment::DATE_SPACER
    else
      @selected_date = Date.new( params[:payable_date][0..3].to_i, 
                                 params[:payable_date][5..6].to_i, 
                                 params[:payable_date][8..9].to_i )
    end
    
    set_instance_variables
    
    respond_to do |format|
      format.html
      format.pdf { render :pdf => @invoices, :type => "application/pdf", :page_size => 'A4' }
    end
  end
  
  def show
    @invoice = Invoice.new(params[:invoice])
    respond_to do |format|
      format.pdf { render :pdf => @invoice, :type => "application/pdf", :page_size => 'A4' }
    end
  end
  
  def settle
    invoice = Invoice.new(params[:invoice])
    invoice.settled = true
    invoice.save
    redirect_to invoices_path(:payable_date => invoice.payment_date.to_s)
  end
  
  def unsettle
    invoice = Invoice.find(params[:id])
    invoice.destroy
    redirect_to invoices_path(:payable_date => invoice.payment_date.to_s)
  end
  
  private
  
  def set_instance_variables
    @invoices, @expected_invoices_sum, @settled_invoices_sum, @unsettled_invoices_sum = Invoice.invoices_expected_settled_and_unsettled_sum_on_date(@selected_date)
  end
  
  def set_section
    @section = :invoices
  end
  
end