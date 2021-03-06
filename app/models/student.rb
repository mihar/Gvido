class Student < Person
  has_many :personal_contacts
  has_many :enrollments, :dependent => :destroy
  has_many :monthly_lessons, :dependent => :destroy
  has_many :invoices
  belongs_to  :status
  belongs_to  :billing_option
  belongs_to  :contact
  
  after_create :proper_reference_number, :set_contact_to_processed
  
  validates_presence_of :status_id
  
  default_scope order('id DESC')
  
  class << self    
    def active_students
      @active_students ||= self.where(:id => Enrollment.active.map(&:student_id))
    end
    
    def future_students
      @future_students ||= self.where(:id => Enrollment.future.map(&:student_id))
    end
    
    def past_students
      @past_students ||= self.where(:id => Enrollment.past.map(&:student_id))
      @past_students - self.active_students - self.future_students
    end
    
    def with_no_enrollments
      @enrolled_student_ids ||= Enrollment.select("DISTINCT(student_id)").to_a.map(&:student_id)
      self.all - self.where(:id => @enrolled_student_ids)
    end
  end
  
  def monthly_reference_for_date(date)
    active_enrollment = Enrollment.for_student(id).including_date(date).reload.first
    month_ref = "%02d" % date.month
    year_ref = Date.year_reference(active_enrollment.enrollment_date, active_enrollment.cancel_date)
    "8#{month_ref}#{year_ref}-#{reference_number}"
  end
  
  def sum_of_settled_invoices
    invoices(true).settled.map(&:price).sum
  end
  
  def sum_of_settled_invoices_for_active_enrollments
    start_enrollment  = enrollments.active.order("enrollment_date ASC").limit(1).first
    stop_enrollment   = enrollments.active.order("cancel_date DESC").limit(1).first
    
    if start_enrollment and stop_enrollment
      Invoice.for_student_between_dates(id, start_enrollment.enrollment_date, stop_enrollment.cancel_date).sum(:price)
    else
      0
    end
  end
  
  def sum_of_unsettled_invoices_for_active_enrollmetns
    enrollments.active.collect {|enrollment| enrollment.sum_of_payments }.sum - sum_of_settled_invoices_for_active_enrollments
  end
  
  protected
  
  def proper_reference_number
    self.reference_number = 100 + id
    self.save
  end
  
  def set_contact_to_processed
    if contact
      contact.processed = true
      contact.save
    end
  end
  
end
