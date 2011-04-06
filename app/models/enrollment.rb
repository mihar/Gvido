class Enrollment < ActiveRecord::Base  
  has_many :payments
  belongs_to :instrument
  belongs_to :mentor
  belongs_to :student
  validates_numericality_of :payment_period,    :only_integer => true, :greater_than_or_equal_to => 1
  validates_numericality_of :lessons_per_month, :only_integer => true, :greater_than_or_equal_to => 1
  validates_numericality_of :total_price,       :greater_than_or_equal_to => 0
  validates_numericality_of :prepayment,        :greater_than_or_equal_to => 0
  validates_numericality_of :discount,          :greater_than_or_equal_to => 0
  validates_presence_of :instrument_id, :mentor_id
  
  validate :cancel_date_correctness, :enrollment_date_acceptance, :mentors_instrument_correctness
  
  after_create   :create_payments
  after_update   :update_payments
  before_destroy :destroy_unsettled_payments
  
  attr_accessor :billable_months
  
  scope :active, where("enrollment_date < CURRENT_DATE() AND cancel_date > CURRENT_DATE() AND deleted = 0")
  
  DATE_SPACER = 19
  
  def discount_percent
    "#{discount * 100}%".gsub(".", ",")
  end
  
  def discount_percent=(_discount)
    discount_without_percent = BigDecimal _discount.gsub("%", "").gsub(",", ".")
    self.discount = discount_without_percent / 100
  end
  
  def lessons_per_period
    return lessons_per_month * payment_period
  end
  
  def destroy_unsettled_payments
    Payment.destroy_unsettled_payments_for_enrollment(id)
  end
  
  private
  
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

  def mentors_instrument_correctness
    errors.add :instrument, "Izbran mentor ne poučuje tega predmeta" if !Mentor.find(mentor_id).instrument_ids.include?(instrument_id)
  end
  
  def create_payments
    set_billable_months
    create_new_payments
  end
  
  #destroys unsettled payments and creates new ones
  def update_payments
    set_billable_months
    @billable_months -= Payment.settled_payment_dates_for_enrollment(id)
    Payment.destroy_unsettled_payments_for_enrollment(id)
    create_new_payments
  end
  
  #creates a payment for every billable month
  def create_new_payments
    @billable_months.each do |payment_date|
      calculated_price = calculate_price
      if payment_date == @billable_months.first or payment_date == @billable_months.last
        calculated_price = calculate_price(true)
      end
      Payment.create do |p|
        p.enrollment_id = id
        p.payment_date = payment_date
        p.calculated_price = calculated_price
        p.settled = false
      end
    end
  end
  
  
  def set_billable_months
    start, stop = enrollment_date, cancel_date
    month_diff = stop.year == start.year ? stop.month - start.month : stop.month + (stop.year - start.year) * 12 - start.month
    
    #maps all months starting with enrollment_date and excluding cancel_date
    months = month_diff.times.map { |i| start + DATE_SPACER >> i } 
    
    if payment_period > 1
      #gets first month in each payable period 
      @billable_months = months.in_groups_of(payment_period).map {|i| i[0] }
    else
      @billable_months = months
    end  
  end
    
  def calculate_price(prepayment_cash_date = false)   
    calculus = total_price / @billable_months.length
    if prepayment_cash_date
      calculus -= prepayment / 2
    end
    calculus -= calculus * discount
    return calculus
  end
  
end

