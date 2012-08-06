class Notice < ActiveRecord::Base
  scope :non_expired, where("expires_at > NOW()").order("created_at DESC")
  
  validates_presence_of :title, :body
  has_attached_file :photo, 
                    :styles => { :square => "75x75#", :small => "150x150#", :medium => "180x180#", :normal => "550x550>" },
                    :whiny => false,
                    :storage => :s3,
                    :bucket => AWS_S3['bucket'],
                    :s3_credentials => {
                      :access_key_id => AWS_S3['access_key_id'],
                      :secret_access_key => AWS_S3['secret_access_key']
                    },
                    :path => '/assets/notices/:id/:style/:basename.:extension'
                
  
  
  def body_html
    RedCloth.new(self.body).to_html
  end
end
