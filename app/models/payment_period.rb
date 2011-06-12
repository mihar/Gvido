class PaymentPeriod < ActiveRecord::Base
  belongs_to :enrollment
  has_many :monthly_lessons, :dependent => :destroy
  
  after_create   :create_or_update_monthly_lessons_and_invoices
  before_update  :handle_payment_period_changes
  before_destroy :destroy_invoices_and_monthly_lessons_between_start_and_end_date
  
  
  validates_numericality_of :discount, :greater_than_or_equal_to => 0
  validate :start_date_correctness, :end_date_correctness, :prev_end_date_eql_start_date, :payment_plan_correctness
  
  
  def student
    enrollment.student
  end
  
  def payment_plan
    @payment_plan ||= PaymentPlan.find payment_plan_id
  end
  
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
  
  class << self
    def for_payment_date(payment_date)
      where("start_date < ? AND end_date > ?", payment_date, payment_date).all
    end
    
    def last_for_enrollment(_enrollment_id)
      where(:enrollment_id => _enrollment_id).order('payment_periods.end_date DESC').limit(1).first
    end
    
    def for_enrollment(_enrollment_id)
      where(:enrollment_id => _enrollment_id).reload
    end
    
    def for_enrollment_between_dates(_enrollment_id, _start_date, _stop_date)
      where(:enrollment_id => _enrollment_id, :start_date => _start_date.._stop_date).reload
    end
  end
  
  private
  
  def parse_enrollment
    _enrollment =  enrollment
    [_enrollment, _enrollment.mentor_id, _enrollment.student_id, Date.year_reference(_enrollment.enrollment_date, _enrollment.cancel_date)]
  end
  
  def get_dates_and_monthly_reference_nr(add_months, student_id, year_ref, payment_date_and_monthly_reference = false)
    date_at_beginning_of_month = (start_date >> add_months)
    payment_date = date_at_beginning_of_month + Payment::DATE_SPACER
    month_ref = "%02d" % date_at_beginning_of_month.month
    monthly_reference = "8#{month_ref}#{year_ref}-#{student.reference_number}"
    if payment_date_and_monthly_reference
      return [payment_date, monthly_reference]
    else
      return [date_at_beginning_of_month, payment_date, monthly_reference]
    end
  end
  
  def create_or_update_monthly_lessons_and_invoices
    _enrollment, mentor_id, student_id, year_ref = parse_enrollment
    length.times do |add_months|
      date_at_beginning_of_month, payment_date, monthly_reference = get_dates_and_monthly_reference_nr(add_months, student_id, year_ref)      
      monthly_lesson = MonthlyLesson.find_or_create_by_mentor_id_and_student_id_and_enrollment_id_and_payment_period_id_and_date(mentor_id, student_id, enrollment_id, id, date_at_beginning_of_month)
    end
  end
    
  def destroy_invoices_and_monthly_lessons_between_start_and_end_date
    destroy_invoices_and_monthly_lessons_between_dates(start_date, end_date)
  end
  
  def handle_payment_period_changes
    if self.end_date_changed?
      if self.end_date < self.end_date_was 
        destroy_invoices_and_monthly_lessons_between_dates(self.end_date, self.end_date_was)
      else
        create_or_update_monthly_lessons_and_invoices
      end
    else
      create_or_update_monthly_lessons_and_invoices
    end
  end
  
  
  def student_has_more_then_one_enrollment_between_dates(student_id, _start_date, _end_date)
    students_current_enrollments = Enrollment.for_student_including_dates(student_id, _start_date, _end_date)
    return students_current_enrollments.length > 1
  end
  
  def destroy_invoices_and_monthly_lessons_between_dates(new_payment_period_end_date, previous_end_date)
    student_id = student.id
    
    if student_has_more_then_one_enrollment_between_dates(student_id, new_payment_period_end_date, previous_end_date)
      useless_monthly_lessons = MonthlyLesson.for_payment_period_between_dates(id, new_payment_period_end_date, previous_end_date)
      useless_monthly_lessons.destroy_all unless useless_monthly_lessons.empty?
      create_or_update_monthly_lessons_and_invoices
    
    else
      useless_invoices = Invoice.for_student_between_dates(student_id, new_payment_period_end_date, previous_end_date)
      useless_monthly_lessons = MonthlyLesson.for_payment_period_between_dates(id, new_payment_period_end_date, previous_end_date)
      
      settled_invoices = useless_invoices.reject {|inv| inv.settled == false }   
      if settled_invoices.empty?
        useless_invoices.destroy_all unless useless_invoices.empty?
        useless_monthly_lessons.destroy_all unless useless_monthly_lessons.empty?
        create_or_update_monthly_lessons_and_invoices
      else
        dates_in_text = settled_invoices.map(&:payment_date).each.map {|date| I18n.l date, :format => :default}.join(', ')
        errors[:base] << dates_in_text + " obstaja plačana položnica, zato ne morete skrajšati plačilnega obdobja na želeno vrednost."
        return false
      end
    end
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
    existing_payment_periods = enrollment.payment_periods(true).order(:id).reload
    return if existing_payment_periods.empty? #TODO or existing_payment_periods.first.present? and existing_payment_periods.first.id != self.id
    
    return if existing_payment_periods.length == 1 and existing_payment_periods.first.id == self.id
    
    last_end_date = existing_payment_periods.last.end_date
    
    if last_end_date < enrollment.cancel_date and last_end_date != start_date
      errors.add :start_date, "Datum začetka plačilnega obdobja mora biti isti datumu konca predhodnega plačilnega obdobja (#{I18n.l(last_end_date, :format => :default)})"
    end
  end
  
  def payment_plan_correctness
    unless payment_plan_id
      errors.add :payment_plan_id, "Mora biti izbran #{payment_plan_id}"
    else
      if enrollment.price_per_lesson > 0.0 and payment_plan.id != :per_hour
        errors.add :payment_plan_id, "Pri urnem plačilu je možen samo mesečni plačilni plan"
      else
        if payment_plan.id == :trimester
          unless [9, 12, 3].include? start_date.month
            errors.add :start_date, "Trimesterski plačilni plan je možen samo v septembru, decembru in marcu"
          end
          unless [12, 3, 6].include? end_date.month
            errors.add :end_date, "Trimesterski plačilni plan se lahko konča samo v decembru, marcu in juniju"
          end
        elsif payment_plan.id == :singular
          unless start_date.month == 9 and end_date.month == 6
            errors.add :end_date, "Enkratni plačilni plan je možen samo za celoleten vpis od spetembra do junija"
          end
        end
      end
    end
  end
  
end
