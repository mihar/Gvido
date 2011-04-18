class Mentor < ActiveRecord::Base
  has_one :user
  has_and_belongs_to_many :instruments
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :gigs
  has_many :enrollments, :conditions => "enrollment_date < CURRENT_DATE() AND cancel_date > CURRENT_DATE() AND deleted = 0", :dependent => :destroy

  accepts_nested_attributes_for :user

  default_scope order(:position)

  validates_uniqueness_of :email
  validates_presence_of :name, :surname, :email, :price_per_private_lesson, :price_per_public_lesson
  validates_numericality_of :price_per_private_lesson, :greater_than_or_equal_to => 0
  validates_numericality_of :price_per_public_lesson,  :greater_than_or_equal_to => 0
  validate :validate_user_presence

  before_save :make_permalink
  before_validation :push_user_attributes, :if => Proc.new { |mentor| mentor.user.present? }

  
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
  
  def to_s
    full_name
  end
  
  private
  
  def push_user_attributes
    self.user.first_name = name
    self.user.last_name = surname
    self.user.email = email
  end
  
  def validate_user_presence
    unless user
      errors.add :user, "mora biti podan"
    end
  end
  
  def make_permalink
    self.permalink = self.full_name.make_websafe
  end
  
end
