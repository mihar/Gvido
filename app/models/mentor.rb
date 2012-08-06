class Mentor < ActiveRecord::Base
  has_one :user
  has_and_belongs_to_many :instruments
  has_and_belongs_to_many :locations
  has_and_belongs_to_many :gigs
  has_many :enrollments, :conditions => "enrollment_date < '#{Date.today}' AND cancel_date > '#{Date.today}' AND deleted = 0", :dependent => :destroy
  has_many :students, :through => :enrollments
  has_many :monthly_lessons
  has_many :expenses

  accepts_nested_attributes_for :user

  default_scope order(:position)
  scope :referents, where(:referent => true)

  validates_uniqueness_of :email
  validates_presence_of :name, :surname, :email, :price_per_private_lesson, :public_lesson_coefficient
  validates_numericality_of :price_per_private_lesson, :greater_than => 0
  validates_numericality_of :public_lesson_coefficient,  :greater_than => 0
  validate :validate_user_presence

  before_save :make_permalink
  before_validation :push_user_attributes, :if => Proc.new { |mentor| mentor.user.present? }

  
  has_attached_file :photo, 
                    :styles => { :square => "75x75#", :small => "150x150#", :medium => "180x180#", :normal => "550x550>" },
                    :url  => "/system/mentors/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/mentors/:id/:style/:basename.:extension"
  
  
  class << self
    def ids_with_user_accounts
      @mentor_ids_with_user_accounts ||= User.where(:admin => false).map(&:mentor_id)
    end
    
    def mentors_with_user_accounts
      @mentors_with_user_accounts ||= self.where(:id => self.ids_with_user_accounts)
    end
    
    def without_user_accounts
      @mentors_without_user_accounts ||= self.order("mentors.name ASC, mentors.surname ASC") - self.where(:id => self.ids_with_user_accounts)
    end
    
    
    # Returns an array of hashes containing payment_date and inactive mentors on that payment date
    # [{:inactive_mentors => [#<Mentor >, #<Mentor>, ..], :payment_date => Mon, 20 Apr 2011}, {:inactive_mentors => [#<Mentor >],  :payment_date => Mon, 20 May 2011}]
    #
    def inactive_on_date(date)
      inactive_mentors = []
      payment_dates = Enrollment.payment_dates_array_up_to_date(date)

      for payment_date in payment_dates
        mentors = []
        self.with_monthly_lessons_up_to_date(payment_date).each do |mentor|
          if mentor.last_hours_entry_at.present? == false
            mentors << mentor
          else
            mentors << mentor if mentor.last_hours_entry_at < payment_date.at_beginning_of_month
          end
        end
        
        inactive_mentors  << { :payment_date => payment_date, :inactive_mentors => mentors } if mentors.any?
      end
      
      return inactive_mentors
    end
    
    # Returns am array of mentors with monthly lessons
    #
    def with_monthly_lessons_up_to_date(date)
      mentors_with_monthly_lessons_up_to_date = []
      self.all.each do |mentor| 
        mentors_with_monthly_lessons_up_to_date << mentor if MonthlyLesson.on_month_for_mentor(date, mentor.id).any?
      end
      mentors_with_monthly_lessons_up_to_date.uniq
    end
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
