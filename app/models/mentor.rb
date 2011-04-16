class Mentor < ActiveRecord::Base
  has_and_belongs_to_many :instruments
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :gigs
  has_many :enrollments, :conditions => "enrollment_date < CURRENT_DATE() AND cancel_date > CURRENT_DATE() AND deleted = 0", :dependent => :destroy

  belongs_to :user, :dependent => :destroy

  default_scope order('position')

  attr_accessor :private_email, :password, :password_confirmation
  
  validates_presence_of :name, :surname, :price_per_private_lesson, :price_per_public_lesson
  validates_numericality_of :price_per_private_lesson, :greater_than_or_equal_to => 0
  validates_numericality_of :price_per_public_lesson,  :greater_than_or_equal_to => 0
  
  validate :user_creation_validation
  
  before_save :make_permalink
  before_create :mentor_user_creation
  
  
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
  
  def make_permalink
    self.permalink = self.full_name.make_websafe
  end
  
  def mentor_user_creation
    if user.nil?
      mentor_user = User.new(
        :first_name => self.name, 
        :last_name => self.surname, 
        :email => self.private_email,
        :password => self.password, 
        :password_confirmation => self.password_confirmation
        )
      if mentor_user.save
        self.user = mentor_user
      end
    end
  end

  def user_creation_validation
    if user.nil?
      mentors_login_account_validation
    end
  end
  
  def mentors_login_account_validation
    if private_email and !private_email.empty?
      #mail validations?
    else
      errors.add :private_email, "ne sme biti prazno"
    end
    
    if password and !password.empty?
      errors.add :password, "geslo mora vsebovati vsaj 6 znakov" if password.length < 6
    else
      errors.add :password, "ne sme biti prazno"
    end
    
    if password_confirmation and !password_confirmation.empty?
      errors.add :password_confirmation, "geslo in potrditev gesla se morata ujemati" if password and password_confirmation != password
    else
      errors.add :password_confirmation, "ne sme biti prazno"
    end
  end
  
end
