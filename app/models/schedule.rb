class Schedule < ActiveRecord::Base
  has_attached_file :file,
                    :whiny => false,
                    :storage => :s3,
                    :bucket => AWS_S3['bucket'],
                    :s3_credentials => {
                      :access_key_id => AWS_S3['access_key_id'],
                      :secret_access_key => AWS_S3['secret_access_key']
                    },
                    :path => '/assets/schedules/:id/:style/:basename.:extension'
  validates_attachment_presence :file
  validates_presence_of :title
end
