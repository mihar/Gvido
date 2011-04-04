class Student < Person
  has_many :personal_contacts
  has_many :enrollments
  has_many :lessons
  belongs_to  :status
  belongs_to  :billing_option
  belongs_to  :contact
  
  after_create :proper_reference_number
  
  validates_presence_of :status_id
  
  default_scope order('id DESC')
  
  scope :enrolled, find_by_sql("SELECT DISTINCT p.* FROM people p, enrollments e 
          WHERE 
            p.type = 'student' AND 
            p.id = e.student_id AND
            e.enrollment_date < CURRENT_DATE() AND e.cancel_date > CURRENT_DATE()
          ORDER BY p.last_name ASC")
  
  def payments
    payments = []
    enrollments.each do |e|
      e.payments.each do |p|
        payments << p
      end
    end
    payments
  end
  
  protected
  
  def proper_reference_number
    self.reference_number = Digest::SHA1.hexdigest("#{id}").hex.to_s[0..12]
    self.save
  end
end
