class Person < ActiveRecord::Base
  belongs_to :mother, :class_name => 'Person'
  belongs_to :father, :class_name => 'Person'
  belongs_to :post_office
  before_save :proper_titleization
  
  #Sign up statuses
  #UNPROCESSED = 1
  #ADDED = 2
  #PENDING = 3
  #UNSUBSCRIBED = 4

  scope :students,  where('student = ?', true).order('first_name ASC, last_name ASC')
  scope :others,    where('student = ?', false).order('id DESC')
  
  validates_presence_of :first_name, :last_name
    
  
  def full_name
    if first_name and last_name
      "#{first_name} #{last_name}"
    end
  end
  
  def proper_titleization
    self.first_name = first_name.titleize
    self.last_name = last_name.titleize
  end
    
end
