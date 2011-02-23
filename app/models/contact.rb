class Contact < ActiveRecord::Base
  has_and_belongs_to_many :instruments
  has_and_belongs_to_many :locations

  validates_presence_of :name, :email, :instrument_ids, :location_ids
  
  #validate :relation_ids_emptiness
  #
  #def relation_ids_emptiness	
  #  errors.add :instrument_ids,  "Izbran mora biti vsaj en instrument"   if instruments.empty?
  #  errors.add :location_ids,    "Izbrana mora biti vsaj ena lokacija"   if locations.empty?
  #end
end
