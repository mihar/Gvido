class PostOffice < ActiveRecord::Base
  set_primary_key :id

  has_many :people
  has_many :locations
  
  validates_presence_of :name, :id
  validates_uniqueness_of :name, :id
  validates_numericality_of :id
  
  attr_accessible :id, :name
  
  default_scope order(:name)
  
  def to_s
    name
  end
end
