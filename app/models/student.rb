class Student < Person
  has_many :personal_contacts
  has_many :enrollments
  belongs_to  :status
  
  after_create :proper_reference_number
  
  validates_presence_of :status_id
  
  default_scope order('id DESC')
  
  scope :statusars, where('status_id = 3')
  
  protected
  
  def proper_reference_number
    self.reference_number = Digest::SHA1.hexdigest("#{id}").hex.to_s[0..12]
    self.save
  end
end
