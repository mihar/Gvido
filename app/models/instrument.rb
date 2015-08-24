class Instrument < ActiveRecord::Base
  has_and_belongs_to_many :mentors
  has_and_belongs_to_many :contacts
  has_many :shop_advices, :dependent => :destroy
  has_many :enrollments
  
  validates_presence_of :title
  before_save :make_permalink


  has_attached_file :icon, :styles => { :small => "30x30#", :medium => "50x50#", :normal => "150x150#" },
                    :whiny => false,
                    :storage => :s3,
                    :bucket => AWS_S3['bucket'],
                    :s3_credentials => {
                      :access_key_id => AWS_S3['access_key_id'],
                      :secret_access_key => AWS_S3['secret_access_key']
                    },
                    :path => '/assets/instruments/:id/:style/:basename.:extension'
  
  def to_param
    permalink
  end
  
  def locations
    mentors.map do |m|
      m.locations
    end.flatten.uniq
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
  
  def to_s
    title
  end
  
  private
  
  def make_permalink
    self.permalink = self.title.make_websafe
  end
end
