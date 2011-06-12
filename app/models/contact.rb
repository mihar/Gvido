class Contact < ActiveRecord::Base
  has_one :student
  has_and_belongs_to_many :instruments
  has_and_belongs_to_many :locations

  validates_presence_of :name, :email
  validate :must_have_instrument_and_location
  before_save :titleize_name  
  
  def must_have_instrument_and_location
    errors.add :instrument_ids,  "Izbran mora biti vsaj en instrument"   if instruments.empty?
    errors.add :location_ids,    "Izbrana mora biti vsaj ena lokacija"   if locations.empty?
  end
 
  scope :processed,   where("processed = ?", true ).order("created_at DESC").reload
  scope :unprocessed, where("processed = ?", false).order("created_at DESC").reload
  
  
  private
  
  def titleize_name
    self.name = name.titleize
  end
end
