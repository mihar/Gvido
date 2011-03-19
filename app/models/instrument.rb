class Instrument < ActiveRecord::Base
  has_and_belongs_to_many :mentors
  has_and_belongs_to_many :contacts
  has_many :shop_advices, :dependent => :destroy
  has_many :enrollments
  
  validates_presence_of :title
  before_save :make_permalink
  
  def to_param
    permalink
  end
  
  def locations
    mentors.map do |m|
      m.locations
    end.flatten.uniq
  end
  
  def icon
    "instruments/" + self.title.make_websafe + ".png"
  end
  def icon_medium
    "instruments/medium/" + self.title.make_websafe + ".png"
  end
  def icon_small
    "instruments/small/" + self.title.make_websafe + ".png"
  end
  
  def make_permalink!
    make_permalink
    save
  end
  
  def shop_instructions_html
    RedCloth.new(shop_instructions).to_html unless shop_instructions.nil?
  end
  
  def shop_instructions_short
    (shop_instructions[0..196] + "...") unless shop_instructions.nil?
  end
  
  def shop_instructions_html_short
    RedCloth.new(shop_instructions_short).to_html unless shop_instructions.nil?    
  end
  
  private
  
  def make_permalink
    self.permalink = self.title.make_websafe
  end
end
