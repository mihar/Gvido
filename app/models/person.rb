class Person < ActiveRecord::Base
  belongs_to :mother, :class_name => 'Person'
  belongs_to :father, :class_name => 'Person'
  belongs_to :social_role
  validates_presence_of :first_name, :last_name
  
  #Sign up statuses
  UNPROCESSED = 1
  ADDED = 2
  PENDING = 3
  UNSUBSCRIBED = 4
end
