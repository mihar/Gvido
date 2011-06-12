class Notice < ActiveRecord::Base
  scope :non_expired, where("expires_at > NOW()").order("created_at DESC")
  
  validates_presence_of :title, :body
  has_attached_file :photo, 
                    :styles => { :square => "75x75#", :small => "150x150#", :medium => "180x180#", :normal => "550x550>" },
                    :url  => "/system/notices/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/notices/:id/:style/:basename.:extension"
                
  
  
  def body_html
    RedCloth.new(self.body).to_html
  end
end
