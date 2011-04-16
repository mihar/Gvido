class Enrollment < ActiveRecord::Base  
  has_many :payments
  belongs_to :instrument
  belongs_to :mentor
  belongs_to :student
  
  validates_numericality_of :payment_period,    :only_integer => true, :greater_than_or_equal_to => 1
  validates_numericality_of :lessons_per_month, :only_integer => true, :greater_than_or_equal_to => 1
  validates_numericality_of :enrollment_fee,    :greater_than_or_equal_to => 0.0
  validates_numericality_of :total_price,       :greater_than_or_equal_to => 0
  validates_numericality_of :prepayment,        :greater_than_or_equal_to => 0
  validates_numericality_of :discount,          :greater_than_or_equal_to => 0
  validates_presence_of :instrument_id, :mentor_id
  
  validate :cancel_date_correctness, :enrollment_date_acceptance
  
  after_create   :create_payments
  after_update   :update_payments
  before_destroy :destroy_unsettled_payments
  
  before_validation do
    return unless payment_plan
    
    case payment_plan.id
      when :monthly then self.payment_period = 1
      when :trimester then self.payment_period = 3
      when :singular then self.payment_period = length
    end
  end
  
  attr_accessor :billable_months
  
  scope :active, where("enrollment_date < CURRENT_DATE() AND cancel_date > CURRENT_DATE() AND deleted = 0")
  composed_of :prepayment_payment_date,
                :class_name => 'Date',
                :mapping => %w(Date to_date),
                :constructor => Proc.new{ Date.today },
                :converter => Proc.new{ |item| item }
  
  composed_of :enrollment_fee_payment_date,
                :class_name => 'Date',
                :mapping => %w(Date to_date),
                :constructor => Proc.new{ Date.today },
                :converter => Proc.new{ |item| item }
                
  DATE_SPACER = 19
  
  def payment_plan
    @payment_plan ||= PaymentPlan.find payment_plan_id
  end
  
  def discount_percent
    "#{discount * 100}%".gsub(".", ",")
  end

  def discount_percent=(_discount)
    discount_without_percent = BigDecimal _discount.gsub("%", "").gsub(",", ".")
    self.discount = discount_without_percent / 100
  end
  
  def destroy_unsettled_payments
    payments.unsettled.each(&:destroy)
  end
  
  def length
    start, stop = enrollment_date, cancel_date
    stop.year == start.year ? stop.month - start.month : stop.month + (stop.year - start.year) * 12 - start.month
  end
  
  private
  
  ###### CALCULATIONS ######
  
  def create_payments
    set_billable_months
    create_payment_for_enrollment_fee
    create_payment_for_prepayment
    create_new_payments
  end
  
  def create_payment_for_enrollment_fee
    if enrollment_fee > 0
      Payment.create do |p|
        p.enrollment_id = id
        p.payment_date = enrollment_fee_payment_date
        p.calculated_price = enrollment_fee
        p.payment_kind = Payment::PAYMENT_KIND[:enrollment_fee]
        p.settled = false
      end
    end
  end
  
  def create_payment_for_prepayment
    if prepayment > 0
      Payment.create do |p|
        p.enrollment_id = id
        p.payment_date = prepayment_payment_date.to_date
        p.calculated_price = prepayment
        p.payment_kind = Payment::PAYMENT_KIND[:prepayment]
        p.settled = false
      end
    end
  end
  
  #destroys unsettled payments and creates new ones
  def update_payments
    set_billable_months
    @billable_months -= payments.settled.regular(true).map(&:payment_date)
    payments.unsettled.regular(true).each(&:destroy)
    create_new_payments(true)
  end
  
  #creates a payment for every billable month
  def create_new_payments(updating = false)
    @billable_months.each do |payment_date|
      
      payment_kind = Payment::PAYMENT_KIND[:regular]
      
      #checks if prepayment should be deducted or not
      if payment_date == @billable_months.first or payment_date == @billable_months.last
        if updating
          calculated_price, payment_kind = irregular_first_or_last_payment_situation(payment_date)
        else
          calculated_price, payment_kind = first_or_last_payment_situation
        end
      else
        calculated_price = updating ? calculate_price(false, true) : calculate_price
      end

      Payment.create do |p|
        p.enrollment_id = id
        p.payment_date = payment_date
        p.payment_kind = payment_kind
        p.calculated_price = calculated_price
        p.settled = false
      end
    end
  end

  def settled_payment_types
    payments.settled.regular(true).map(&:payment_kind)
  end
    
  def irregular_first_or_last_payment_situation(payment_date)
    if payments.settled.regular(true).empty?
      #no exceptions to deal with
      return first_or_last_payment_situation(true)
    else
      types = settled_payment_types

      if types.include?(Payment::PAYMENT_KIND[:full_prepayment_deducted])
        return [ calculate_price(false, true), Payment::PAYMENT_KIND[:regular] ]
      else
        case types.count(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          when 0 then return first_or_last_payment_situation(true)
          when 2 then return [ calculate_price(false, true), Payment::PAYMENT_KIND[:regular] ]
        else
          if (@billable_months.length > 1 and payment_date == @billable_months.last) or
             (@billable_months.length == 1)
            return [ calculate_price(true, true), Payment::PAYMENT_KIND[:half_prepayment_deducted]]
          else
            return [ calculate_price(false, true), Payment::PAYMENT_KIND[:regular] ]
          end
        end
      end 
    end
  end
  
  def first_or_last_payment_situation(updating = false)
    if prepayment > 0
      if (payment_plan.singular?) or
        (payment_plan.trimester? and length == 3) or
        (payment_plan.monthly? and length == 1) 
        return [ calculate_price(true, updating, true), Payment::PAYMENT_KIND[:full_prepayment_deducted] ]
      else
        return [ calculate_price(true, updating), Payment::PAYMENT_KIND[:half_prepayment_deducted] ]
      end
    else
      return [ calculate_price(false, updating), Payment::PAYMENT_KIND[:regular] ]
    end  
  end
  
  def set_billable_months
    #maps all months starting with enrollment_date and excluding cancel_date
    months = length.times.map { |i| enrollment_date + DATE_SPACER >> i } 
    
    if payment_period > 1
      #gets first month in each payable period 
      @billable_months = months.in_groups_of(payment_period).map {|i| i[0] }
    else
      @billable_months = months
    end  
  end
  
  def deducted_from_prepayment
    types = settled_payment_types
    if types.include?(Payment::PAYMENT_KIND[:full_prepayment_deducted])
      return prepayment
    end
    case types.count(Payment::PAYMENT_KIND[:half_prepayment_deducted])
      when 0 then return 0.0
      when 1 then return prepayment / 2
      when 2 then return prepayment
    end
  end
  
  def calculate_price(prepayment_cash_date = false, updating = false, full_prepayment_deduction = false)
    Rails.logger.info ""
    Rails.logger.info "------------------------------------- CALCULATION START -"
    Rails.logger.info "---------------------------------------------------------"
    Rails.logger.info "prepayment_cash_date =  #{prepayment_cash_date.to_s}"
    Rails.logger.info "---------------------------------------------------------"
    Rails.logger.info "updating = #{updating.to_s}"
    Rails.logger.info "---------------------------------------------------------"
    Rails.logger.info "@billable_months.length = #{@billable_months.length}"
    Rails.logger.info "---------------------------------------------------------"
    Rails.logger.info "length = #{length}"
    Rails.logger.info "---------------------------------------------------------"
    Rails.logger.info "total_price = #{total_price}"
    Rails.logger.info "---------------------------------------------------------"
    Rails.logger.info "discount = #{discount}"
    Rails.logger.info "---------------------------------------------------------"
    Rails.logger.info ""
    
    if updating
      sum_of_settled_payments = payments.settled.regular(true).map(&:calculated_price).sum
      calculus = (total_price - sum_of_settled_payments - deducted_from_prepayment) / @billable_months.length
      Rails.logger.info "-- updated calculation = #{calculus}"
    else
      calculus = total_price / @billable_months.length
      Rails.logger.info "-- normal calculation = #{calculus}"
    end
    
    if prepayment_cash_date
      calculus -= full_prepayment_deduction ? prepayment : prepayment / 2
      Rails.logger.info "-- calculation after deducted prepayment = #{calculus}"
    end
    
    calculus -= calculus * discount
    Rails.logger.info "-- calculation after deducted discount = #{calculus}"
    Rails.logger.info ""
    Rails.logger.info "---------------------------------------------------------"
    Rails.logger.info "CALCULATED PRICE = #{calculus.round(2)}"
    Rails.logger.info "---------------------------------------------------------"
    Rails.logger.info "-------------------------------------- CALCULATION STOP -"
    Rails.logger.info ""
    
    return calculus.round(2)
  end
  
  ###### VALIDATIONS ######
  
  def cancel_date_correctness
    errors.add :cancel_date, "Datum izpisa mora biti poznejši od datuma vpisa" if cancel_date < enrollment_date
    errors.add :cancel_date, "Učenec ne more biti vpisan in izpisan v istem mesecu" if cancel_date == enrollment_date
  end
  
  def enrollment_date_acceptance
    student.enrollments.each do |enrollment|
      saving = id.nil? 
      
      existing_instrument_enrollment = (
        (instrument_id == enrollment.instrument_id) and
        (mentor_id == enrollment.mentor_id)
      )
      
      invalid_enrollment_date = (
        existing_instrument_enrollment and 
        (enrollment_date >= enrollment.enrollment_date) and
        (enrollment_date < enrollment.cancel_date)
      )
      
      invalid_cancel_date = (
        existing_instrument_enrollment and 
        (cancel_date > enrollment.enrollment_date) and
        (cancel_date <= enrollment.cancel_date)
      )
      
      invalid_embracing_enrollment = (
        existing_instrument_enrollment and 
        (enrollment_date <= enrollment.enrollment_date) and
        (cancel_date >= enrollment.cancel_date)
      )
      
      if invalid_enrollment_date or invalid_cancel_date or invalid_embracing_enrollment
        error_message = "Učenec je že vpisan na izbran program v izbranem obdobju (#{I18n.l enrollment.enrollment_date, :format => :default} - #{I18n.l enrollment.cancel_date - 1, :format => :default})" 
      end
      
      if saving
        add_error(invalid_enrollment_date, invalid_cancel_date, invalid_embracing_enrollment, error_message)
      else #editing
        if id != enrollment.id
          add_error(invalid_enrollment_date, invalid_cancel_date, invalid_embracing_enrollment, error_message)
        end
      end
    end
  end
  
  def add_error(invalid_enrollment_date, invalid_cancel_date, invalid_embracing_enrollment, error_message)
    if invalid_enrollment_date
      errors.add :enrollment_date, error_message
    elsif invalid_cancel_date
      errors.add :cancel_date, error_message
    elsif invalid_embracing_enrollment
      errors.add :enrollment_date, error_message
      errors.add :cancel_date, error_message
    end
  end
  
end

