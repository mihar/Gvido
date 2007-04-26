class Contact < ActiveRecord::Base
  has_and_belongs_to_many :instruments
  has_and_belongs_to_many :locations

  validates_presence_of :name, :email, :instrument_ids, :location_ids
  
  scope :processed,   where('processed = ?', true)
  scope :unprocessed, where('processed = ?', false)
end
