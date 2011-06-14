class PaymentPeriod < ActiveRecord::Base
  belongs_to :enrollment
  has_many :monthly_lessons, :dependent => :destroy
  
  after_create   :create_monthly_lessons
  before_update  :handle_payment_period_changes
  before_destroy :destroy_monthly_lessons_between_start_and_end_date
  
  
  validates_numericality_of :discount, :greater_than_or_equal_to => 0
  validate :start_date_correctness, :end_date_correctness, :prev_end_date_eql_start_date, :payment_plan_correctness
  
  class << self
    def for_payment_date(payment_date)
      where("start_date < ? AND end_date > ?", payment_date, payment_date).all
    end
    
    def last_for_enrollment(_enrollment_id)
      where(:enrollment_id => _enrollment_id).order("end_date DESC").limit(1).first
    end
    
    def for_enrollment(_enrollment_id)
      where(:enrollment_id => _enrollment_id).reload
    end
    
    def for_enrollment_between_dates(_enrollment_id, _start_date, _stop_date)
      where(:enrollment_id => _enrollment_id, :start_date => _start_date.._stop_date).reload
    end
  end
  
  def student
    enrollment.student
  end
  
  def payment_plan
    @payment_plan ||= PaymentPlan.find payment_plan_id
  end
  
  # Returns length of payment period in month count
  #
  def length
    Date.length_in_months(start_date, end_date)
  end
  
  def discount_percent
    "#{discount * 100}%".gsub(".", ",")
  end

  def discount_percent=(_discount)
    discount_without_percent = BigDecimal _discount.gsub("%", "").gsub(",", ".")
    self.discount = discount_without_percent / 100
  end
  
  private
  
  # Returns values for [enrollment, enrollments mentor_id, enrollments student_id, enrollments year_reference (as in 1112 for 2011-2012 enrollment) ]
  #
  def parse_enrollment
    _enrollment =  enrollment
    [_enrollment, _enrollment.mentor_id, _enrollment.student_id, Date.year_reference(_enrollment.enrollment_date, _enrollment.cancel_date)]
  end
  
  # Returns [date_at_beginning_of_month, monthly_reference]
  # 
  def get_date_and_monthly_reference(add_months, year_ref)
    date_at_beginning_of_month = (start_date >> add_months)
    month_ref = "%02d" % date_at_beginning_of_month.month
    monthly_reference = "8#{month_ref}#{year_ref}-#{student.reference_number}"

    [date_at_beginning_of_month, monthly_reference]
  end
  
  # Creates monthly lessons for each month in the enrollment
  #
  def create_monthly_lessons
    _enrollment, mentor_id, student_id, year_ref = parse_enrollment
    length.times do |add_months|
      date_at_beginning_of_month, monthly_reference = get_date_and_monthly_reference(add_months, year_ref)      
      monthly_lesson = MonthlyLesson.find_or_create_by_mentor_id_and_student_id_and_enrollment_id_and_payment_period_id_and_date_and_monthly_reference(mentor_id, student_id, enrollment_id, id, date_at_beginning_of_month, monthly_reference)
    end
    true
  end
  
  def destroy_monthly_lessons_between_start_and_end_date
    destroy_monthly_lessons_between_dates(start_date, end_date)
  end
  
  # Creates or destroys monthly lessons depending on if the payment periods end date became later or earlier than it was
  #
  def handle_payment_period_changes
    if self.end_date_changed?
      if self.end_date < self.end_date_was 
        destroy_monthly_lessons_between_dates(self.end_date, self.end_date_was)
      else
        create_monthly_lessons
      end
    end
  end
  
  # Destroys monthly lessons between previous end date and newly set end date
  #
  def destroy_monthly_lessons_between_dates(new_end_date, previous_end_date)
    useless_monthly_lessons = MonthlyLesson.for_payment_period_between_dates(id, new_end_date, previous_end_date)
    useless_monthly_lessons.destroy_all unless useless_monthly_lessons.empty?
  end
  
  #Validations
  def end_date_correctness
    errors.add :end_date, "Konec plačilnega obdobja je poznejši od konca vpisnine (#{I18n.l(enrollment.cancel_date, :format => :default)})" if end_date > enrollment.cancel_date
    errors.add :end_date, "Konec plačilnega obdobja ne more biti zgodnejši od začetka plačilnega obdobja" if start_date > end_date 
  end
  
  def start_date_correctness
    errors.add :start_date, "Začetek plačilnega obdobja ni enak začetku vpisnine (#{I18n.l enrollment.enrollment_date, :format => :default})" if enrollment.payment_periods(true).empty? and enrollment.enrollment_date != self.start_date
  end
  
  def prev_end_date_eql_start_date
    existing_payment_periods = enrollment.payment_periods.order(:id).reload
    return if existing_payment_periods.empty?
    return if existing_payment_periods.length == 1 and existing_payment_periods.first.id == self.id
    
    last_end_date = existing_payment_periods.last.end_date
    if last_end_date < enrollment.cancel_date and last_end_date != start_date
      errors.add :start_date, "Datum začetka plačilnega obdobja mora biti isti datumu konca predhodnega plačilnega obdobja (#{I18n.l(last_end_date, :format => :default)})"
    end
  end
  
  # Checks if payment plan fits the needs
  #
  def payment_plan_correctness
    unless payment_plan_id
      errors.add :payment_plan_id, "Mora biti izbran #{payment_plan_id}"
    else
      if enrollment.price_per_lesson > 0.0 and not payment_plan.per_hour?
        errors.add :payment_plan_id, "Pri urnem plačilu je možen samo mesečni plačilni plan"
      else
        if payment_plan.trimester?
          unless [9, 12, 3].include? start_date.month
            errors.add :start_date, "Trimesterski plačilni plan je možen samo v septembru, decembru in marcu"
          end
          unless [12, 3, 6].include? end_date.month
            errors.add :end_date, "Trimesterski plačilni plan se lahko konča samo v decembru, marcu in juniju"
          end
        elsif payment_plan.singular?
          unless start_date.month == 9 and end_date.month == 6
            errors.add :end_date, "Enkratni plačilni plan je možen samo za celoleten vpis od spetembra do junija"
          end  
        end
      end
    end
  end
  
end
