class Person < ActiveRecord::Base
  belongs_to :mother, :class_name => 'Person'
  belongs_to :father, :class_name => 'Person'
  
  #Sign up statuses
  #UNPROCESSED = 1
  #ADDED = 2
  #PENDING = 3
  #UNSUBSCRIBED = 4

  scope :students,  where('student = ?', true)
  scope :parents,   where('student = ?', false)
  
  validates_presence_of :first_name, :last_name
  
  def full_name
    if first_name and last_name
      "#{first_name} #{last_name}"
    end
  end 
    
end
