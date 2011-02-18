class Link < ActiveRecord::Base
  belongs_to :category, :class_name => "LinkCategory"
  validates_presence_of :title, :uri
  before_save :normalize_uri
  # before_save :titleize_title
  
  protected
  
  def normalize_uri
    self.uri = uri_normalize(self.uri)
  end
  
  # Function automatically checks if URI has protocol specified, if not it adds the http.
	def uri_normalize(uri)
  	return 'http://' + uri unless uri =~ /http:\/\//
  	uri
	end
	
	def titleize_title
	 self.title = self.title.titleize
	end
end
