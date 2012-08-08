class Banner < ActiveRecord::Base
  attr_accessible :url, :image
  has_attached_file :image,
                    :whiny => false,
                    :storage => :s3,
                    :bucket => AWS_S3['bucket'],
                    :s3_credentials => {
                      :access_key_id => AWS_S3['access_key_id'],
                      :secret_access_key => AWS_S3['secret_access_key']
                    },
                    :path => '/assets/banners/:id/:style/:basename.:extension'
end
