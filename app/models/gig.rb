class Gig < ActiveRecord::Base
  validates_presence_of :title, :venue, :when
  has_and_belongs_to_many :mentors
  
  before_save :format_title
  
  scope :upcoming, where('`when` > NOW()').order('`when`')
  scope :recent, where('`when` > ?', 3.month.ago).order('`when`')
  scope :with_mentors do
    Gig.all.map do |m|
      m unless m.mentors.empty?
    end.flatten.uniq.delete_if { |a| a.nil? }
  #  gigs_with_mentors = []
  #  for gig in all_gigs
  #    if !gig.mentors.empty?
  #      gigs_with_mentors << gig
  #    end
  #  end
  #  gigs_with_mentors
  end 
  
  def upcoming?
    self.when > Time.now
  end
  
  private
  
  def format_title
    self.title = self.title.titleize    
  end
end
