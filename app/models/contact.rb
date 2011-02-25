class Contact < ActiveRecord::Base
  has_and_belongs_to_many :instruments
  has_and_belongs_to_many :locations

  validates_presence_of :name, :email
  validate :must_have_instrument_and_location
  
  def must_have_instrument_and_location
    errors.add :instrument_ids,  "Izbran mora biti vsaj en instrument"   if instruments.empty?
    errors.add :location_ids,    "Izbrana mora biti vsaj ena lokacija"   if locations.empty?
  end
 
  scope :processed,   where('processed = ?', true)
  scope :unprocessed, where('processed = ?', false)
end
