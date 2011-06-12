class Status < ActiveRecord::Base
  has_many :people
  
  def to_s
    short_description
  end
end
