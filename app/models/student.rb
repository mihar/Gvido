class Student < ActiveRecord::Base
  has_many :student_contacts
  has_one :default_contact
  
  validates_presence_of :first_name
  validates_presence_of :last_name
  
  def full_name
    first_name + ' ' + last_name
  end
  
end
