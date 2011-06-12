class Location < ActiveRecord::Base
  has_and_belongs_to_many :mentors
  belongs_to :location_section
  belongs_to :post_office
  before_save :geocode, :normalize_uri
  validates_presence_of :title
  
  attr_accessor :letter
    
  def geocoded?
    !!(self.lat and self.lng)
  end
  
  def geocode
    geo = !address.blank? && !self.post_office.nil? && Geocoder.geocode(self.address, self.city, self.post_office.id)
    
    if geo
      self.lat, self.lng = geo.lat, geo.lng
    else
      self.lat = self.lng = nil
    end
  end

  def geocode!
    geocode
    save(false)
  end
  
  def enrollments
    mentors.map do |m|
      m.enrollments.active
    end.flatten.uniq
  end
  
  def instruments
    mentors.map do |m|
      m.instruments
    end.flatten.uniq
  end
  
  def gmaps4rails_address
    [self.address, self.city, self.post_office.id].join(" ")
  end
  
  def to_s
    title
  end
  
  protected
  
  def normalize_uri
    self.uri = uri_normalize(self.uri) if uri
  end
  
  # Function automatically checks if URI has protocol specified, if not it adds the http.
	def uri_normalize(uri)
  	return "http://#{uri}" unless uri =~ /http:\/\//
  	uri
	end
end
