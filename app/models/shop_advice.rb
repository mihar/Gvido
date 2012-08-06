class ShopAdvice < ActiveRecord::Base
  belongs_to :instrument
  has_attached_file :photo, 
                    :styles => { :mini => "50x50#", :square => "75x75#", :small => "150x150#", :medium => "180x180#", :normal => "550x550>" },
                    :whiny => false,
                    :storage => :s3,
                    :bucket => AWS_S3['bucket'],
                    :s3_credentials => {
                      :access_key_id => AWS_S3['access_key_id'],
                      :secret_access_key => AWS_S3['secret_access_key']
                    },
                    :path => '/assets/shop_advices/:id/:style/:basename.:extension'
  
  def description_html
    RedCloth.new(description).to_html unless description.nil?
  end
end
