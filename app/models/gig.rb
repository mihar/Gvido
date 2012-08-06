class Gig < ActiveRecord::Base
  validates_presence_of :title, :venue, :happening_at
  has_and_belongs_to_many :mentors
  
  before_save :format_title
  
  scope :upcoming, where("happening_at > #{Time.now}").order(:happening_at)
  scope :recent, where('happening_at > ?', 3.month.ago).order(:happening_at)
  
  def self.with_mentors
    Gig.all.reject { |g| g.mentors.empty? }
  end
  
  def upcoming?
    self.happening_at > Time.now
  end
  
  private
  
  def format_title
    self.title = title.titleize    
  end
end
