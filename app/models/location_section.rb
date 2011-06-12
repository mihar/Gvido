class LocationSection < ActiveRecord::Base
  has_many :locations
  
  def to_s
    title
  end
end
