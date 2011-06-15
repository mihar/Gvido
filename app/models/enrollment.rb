class Enrollment < ActiveRecord::Base  
  include ActionView::Helpers::NumberHelper
  
  belongs_to :instrument
  belongs_to :mentor
  belongs_to :student
  has_many :monthly_lessons, :dependent => :destroy
  has_many :payment_periods, :dependent => :destroy
  
  validates_numericality_of :nr_of_lessons,     :only_integer => true, :greater_than_or_equal_to => 1
  validates_numericality_of :enrollment_fee,    :greater_than_or_equal_to => 0.0
  validates_numericality_of :total_price,       :greater_than_or_equal_to => 0
  validates_numericality_of :price_per_lesson,  :greater_than_or_equal_to => 0
  validates_numericality_of :prepayment,        :greater_than_or_equal_to => 0
  validates_numericality_of :discount,          :greater_than_or_equal_to => 0
  validates_presence_of :instrument_id, :mentor_id
  
  validate :cancel_date_correctness, :enrollment_date_acceptance
    
  scope :active, where("enrollments.enrollment_date < CURRENT_DATE()").where("enrollments.cancel_date > CURRENT_DATE()").reload
  scope :future, where("enrollments.enrollment_date > CURRENT_DATE()").reload
  scope :past, where("enrollments.cancel_date < CURRENT_DATE()").reload
  
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
  
  before_update :destroy_out_of_range_payment_periods_and_invoices
  
  class << self
    def active_ids
      self.active.map(&:id)
    end
    
    def active_with_mentor_id(_mentor_id)
      self.where("mentor_id = ? AND enrollment_date < CURRENT_DATE() AND cancel_date > CURRENT_DATE() AND deleted = 0", _mentor_id)
    end
    
    def including_dates(start_date, stop_date)
      self.where("enrollment_date <= ?", start_date).where("cancel_date >= ?", stop_date)
    end
    
    def including_date(date)
      self.where("enrollment_date <= ? AND cancel_date >= ?", date, date)
    end
    
    def for_student(_student_id)
      self.where(:student_id => _student_id)
    end
    
    def for_student_including_dates(_student_id, start_date, stop_date)
      self.for_student(_student_id).including_dates(start_date, stop_date).reload
    end
    
    # Returns a hash :year => [payment_date, payment_date, ..]
    #
    def payment_dates_up_to_date(date)
      self.payment_dates_array_up_to_date(date).group_by(&:year)
    end
    
    # Returns an array of payment dates up do given date
    #
    def payment_dates_array_up_to_date(date)
      start_enrollment = self.order('enrollment_date ASC').limit(1).first
      stop_enrollment  = self.order('cancel_date DESC').limit(1).first
      
      if start_enrollment and stop_enrollment  
        start = start_enrollment.enrollment_date
        stop  = stop_enrollment.cancel_date
        payment_dates_array = []
        
        if date < stop_enrollment.cancel_date
          length_in_months = Date.length_in_months_including_last(start, date)
        else
          length_in_months = Date.length_in_months_including_last(start, stop)
        end
        
        length_in_months.times do |add_month|
          payment_dates_array << ((start + Payment::DATE_SPACER) >> add_month)
        end
        return payment_dates_array
      else
        return []
      end      
    end
  end
    
  def discount_percent
    "#{discount * 100}%".gsub(".", ",")
  end

  def discount_percent=(_discount)
    discount_without_percent = BigDecimal _discount.gsub("%", "").gsub(",", ".")
    self.discount = discount_without_percent / 100
  end
  
  def length
    Date.length_in_months(enrollment_date, cancel_date)
  end
  
  def payments
    @payments ||= (payment_periods(true).map { |period| Payment.create(period) }).flatten
  end
  
  def to_s
    instrument.title + "/" + mentor.full_name
  end
  
  def programme
    instrument.title
  end
  
  def chosen_price_per_hour
    if price_per_lesson and price_per_lesson > 0 
      return price_per_lesson
    else
      return (payments.map(&:price).inject(:+) / nr_of_lessons)
    end
  end
  
  def flat_rate_or_per_hour
    _payment_periods = payment_periods#(true)
    if _payment_periods.any?
      if _payment_periods.first.payment_plan and _payment_periods.first.payment_plan.id == :per_hour
        return "Na uro"
      else
        return "Pavšalno"
      end
    else
      return "Napaka. Izbrišite vpisnino."
    end
  end
  
  def display_nr_of_lessons
    if payment_periods.any? and payment_periods.first.payment_plan.per_hour?
      "X"
    else
      nr_of_lessons
    end
  end
  
  def nr_of_lessons_done
    MonthlyLesson.lessons_done_for_student_with_enrollment(student_id, id)
  end
  
  def sum_of_payments
    payments.map(&:price).inject(:+)
  end
  
  private
  
  def destroy_out_of_range_payment_periods_and_invoices
    if self.changed?
      if self.cancel_date_changed?
        if self.cancel_date < self.cancel_date_was
          useless_payment_periods = PaymentPeriod.for_enrollment_between_dates(id, self.cancel_date, self.cancel_date_was)
          PaymentPeriod.destroy(useless_payment_periods) unless useless_payment_periods.empty?
        end
      else
        soon_to_be_updated_payment_periods = PaymentPeriod.for_enrollment(id)
        soon_to_be_updated_payment_periods.each { |period| period.save }
      end
    end
  end
  
  ###### VALIDATIONS ######
  
  def cancel_date_correctness
    errors.add :cancel_date, "Datum izpisa mora biti poznejši od datuma vpisa" if cancel_date < enrollment_date
    errors.add :cancel_date, "Učenec ne more biti vpisan in izpisan v istem mesecu" if cancel_date == enrollment_date
  end
  
  def enrollment_date_acceptance
    student.enrollments(true).each do |enrollment|
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

