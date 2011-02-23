class Photo < ActiveRecord::Base
  belongs_to :album
  has_attached_file :photo, 
                    :styles => { :mini => "50x50#", :square => "75x75#", :small => "150x150#", :medium => "180x180#", :normal => "550x550>" },
                    :url  => "/system/photos/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/system/photos/:id/:style/:basename.:extension"
  
  validates_attachment_presence :photo
end
