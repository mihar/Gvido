class Mentor < ActiveRecord::Base
  has_and_belongs_to_many :instruments
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :gigs

  default_scope order('position')

  validates_presence_of :name, :surname
  before_save :make_permalink
  
  has_attached_file :photo, 
                    :styles => { :square => "75x75#", :small => "150x150#", :medium => "180x180#", :normal => "550x550>" },
                    :url  => "/system/mentors/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/mentors/:id/:style/:basename.:extension"

 
  def locations_by_city
   @locations ||= locations.map(&:city).uniq
  end
 
  def to_param
    permalink
  end
 
  def full_name
    if name and surname
      "#{name} #{surname}".titleize
    end
  end
  alias_method :title, :full_name
  
  def make_permalink!
    make_permalink
    save
  end
  
  private
  
  def make_permalink
    self.permalink = self.full_name.make_websafe
  end
end
