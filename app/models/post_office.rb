class PostOffice < ActiveRecord::Base
  has_many :people
  
  validates_presence_of :name, :id
  validates_uniqueness_of :name, :id
  validates_numericality_of :id
  
  default_scope order("name")
end
