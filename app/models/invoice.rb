class Invoice < ActiveRecord::Base
  belongs_to :student
  
  scope :due_this_month, where(:payment_date => Date.today.beginning_of_month..Date.today.end_of_month)
  scope :due, where("payment_date < ?", 1.day.from_now).where("settled = ?", false)
  scope :settled, where("settled = ?", true).order('payment_date ASC')
  scope :unsettled, where("settled = ?", false)
  scope :regular, where(:payment_kind => 1..3)
  
  RECIEVERS_NAME = "GVIDO Društvo"
  RECIEVERS_ADDRESS = "Podgorje 49/a"
  RECIEVERS_POST_OFFICE_AND_CITY = "2381, Podgorje/Slovenj Gradec"
  RECIEVERS_IBAN = "SI56 0317 5100 0008 031"
  RECIEVERS_BIC = "SKBASI2X"
  PAYERS_CODE = "OTHR"
  
  class << self
    
    # Returns an array of new invoices for given month
    #
    def new_on_date(date, current_date)
      invoices = []
      if date and date.class == Date
        nr_of_unpaid_months = Date.length_in_months(date, current_date)
        payment_date = date.at_beginning_of_month + Payment::DATE_SPACER
        active_periods = PaymentPeriod.for_payment_date(payment_date)
        students = Hash.new{|h, k| h[k] = []}
        enrollments_with_enrollment_fees = Enrollment.with_enrollment_fees_on_date(date)
        enrollments_with_prepayments = Enrollment.with_prepayments_on_date(date)
        
        #creates payments for active payment periods
        for payment_period in active_periods
          if payment_period.payment_plan.id == :per_hour
            payment_array = Payment.create(payment_period)
            students[payment_array.first.student_id] << payment_array
          else
            #calculated payment for current payment date in an Array
            payment_array = Payment.create(payment_period).reject { |payment| payment.payment_date != payment_date }
    
            #trimester and singular check
            unless payment_array.empty?
              students[payment_array.first.student_id] << payment_array
            end
          end
        end
        
        #creates new invoices and adds them to an array
        for student_id in students.keys
          sum_of_all_monthly_payments = students[student_id].flatten.map(&:price).inject(:+)
          student = Student.find_by_id(student_id)
          invoices << self.new(:student_id => student_id, :monthly_reference => student.monthly_reference_for_date(payment_date), :payers_name => student.full_name, :payers_address => student.full_address, :recievers_name => RECIEVERS_NAME, :recievers_address => RECIEVERS_ADDRESS, :payment_date => payment_date, :price => sum_of_all_monthly_payments, :settled => false) #TODO description..
        end
        
        #creates new invoices for prepayments
        for enrollment in enrollments_with_prepayments
          student = Student.find_by_id(enrollment.student_id)
          invoices << self.new(:student_id => enrollment.student_id, :monthly_reference => "Kavcija", :payers_name => student.full_name, :payers_address => student.full_address, :recievers_name => RECIEVERS_NAME, :recievers_address => RECIEVERS_ADDRESS, :payment_date => enrollment.prepayment_payment_date, :price => enrollment.prepayment, :settled => false) #TODO description..
        end
        
        #creates new invoices for prepayments
        for enrollment in enrollments_with_enrollment_fees
          student = Student.find_by_id(enrollment.student_id)
          invoices << self.new(:student_id => enrollment.student_id, :monthly_reference => "Šolnina", :payers_name => student.full_name, :payers_address => student.full_address, :recievers_name => RECIEVERS_NAME, :recievers_address => RECIEVERS_ADDRESS, :payment_date => enrollment.enrollment_fee_payment_date, :price => enrollment.enrollment_fee, :settled => false) #TODO description..
        end
        
        #adds 3€ to the invoice price for each unpaid month
        for invoice in invoices
          invoice.price = invoice.price + 3 * nr_of_unpaid_months
        end
      end
      return invoices
    end
    
    # Returns saved (settled) invoices for month
    #
    def on_date(date)
      where("YEAR(payment_date) = ?", date.year).where("MONTH(payment_date) = ?", date.month) #where(:payment_date => date)
    end
    
    # Settled invoices for student between dates
    #
    def for_student_between_dates(_student_id, start_date, stop_date)
      where(:student_id => _student_id, :payment_date => start_date..stop_date).reload
    end
    
    # Returns all unsettled invoices on given date
    #
    def unsettled_on_date(date)
      payment_dates = Enrollment.payment_dates_array_up_to_date(date)

      unsettled = []
      if payment_dates.any?
        for payment_day in payment_dates
          saved_invoices = self.on_date(payment_day)
          if saved_invoices.any?
            new_invoices = self.new_on_date(payment_day, date)
            saved_monthly_references = saved_invoices.collect(&:monthly_reference)      
            unsettled += new_invoices.reject { |invoice| saved_monthly_references.include?(invoice.monthly_reference) }
          else
            unsettled += self.new_on_date(payment_day, date)
          end
        end
      end
      unsettled.sort_by {|inv| inv.payment_date}
    end
    
    # Returns values for all invoices, expected invoices sum, settled invoices sum and unsettled invoices sum for given date
    # 
    def invoices_expected_settled_and_unsettled_sum_on_date(date, current_date)
      saved_invoices = self.on_date(date)

      if saved_invoices.any?
        new_invoices = self.new_on_date(date, current_date)
        saved_monthly_references = saved_invoices.collect(&:monthly_reference)
        #reject duplicates by monthly reference code    
        new_invoices = new_invoices.reject { |invoice| saved_monthly_references.include?(invoice.monthly_reference) }
        new_invoices = new_invoices.sort_by {|invoice| invoice.payers_name }
        saved_invoices = saved_invoices.sort_by {|invoice| invoice.payers_name }
        #join new and saved invoices
        all_invoices = new_invoices + saved_invoices
        expected_invoices_sum  = all_invoices.map(&:price).sum
        settled_invoices_sum   = saved_invoices.map(&:price).sum
      else
        all_invoices = Invoice.new_on_date(date, current_date)
        expected_invoices_sum  = all_invoices.map(&:price).sum
        settled_invoices_sum   = 0
      end 
      unsettled_invoices_sum = expected_invoices_sum - settled_invoices_sum
      
      [all_invoices, expected_invoices_sum, settled_invoices_sum, unsettled_invoices_sum]
    end
    
  end # class << self
  
end
