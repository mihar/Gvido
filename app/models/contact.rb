class Contact < ActiveRecord::Base
  has_and_belongs_to_many :instruments
  has_and_belongs_to_many :locations

  validates_presence_of :name, :email
  
  def Base#validate
    errors.add :instrument_ids, "morajo biti izbrani (vsaj en)" if instruments.empty?
    errors.add :location_ids, "morajo biti izbrane (vsaj ena)" if locations.empty?
  end
end
