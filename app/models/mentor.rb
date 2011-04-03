class Mentor < ActiveRecord::Base
  has_and_belongs_to_many :instruments
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :gigs
  has_many :enrollments, :conditions => "enrollment_date < CURRENT_DATE() AND cancel_date > CURRENT_DATE() AND deleted = 0", :dependent => :destroy

  belongs_to :user, :dependent => :destroy

  default_scope order('position')

  attr_accessor :private_email, :password, :password_confirmation
  
  validates_presence_of :name, :surname
  validates_presence_of :password_confirmation, :on => :save
  
  before_save :make_permalink, :create_mentors_user_account
  before_update :update_mentors_user_account
  
  has_attached_file :photo, 
                    :styles => { :square => "75x75#", :small => "150x150#", :medium => "180x180#", :normal => "550x550>" },
                    :url  => "/system/mentors/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/mentors/:id/:style/:basename.:extension"

  #TODO: Create/Update doesn't work for mentors user account!!
  
  def private_email
    user.email if user
  end
  
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
  
  def create_mentors_user_account
    mentor_user = User.new(
      :first_name => name, 
      :last_name => surname, 
      :email => private_email,
      :password => password, 
      :password_confirmation => password_confirmation, 
      :admin => false
      )
    mentor_user.save
    self.user = mentor_user
  end
  
  def update_mentors_user_account
    user.first_name = name 
    user.last_name = surname
    user.email = private_email
    unless password_confirmation.nil?
      user.password = password
      user.password_confirmation = password_confirmation
    end
    user.save
  end
end
