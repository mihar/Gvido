class Schedule < ActiveRecord::Base
  has_attached_file :file,
                    :url  => "/assets/schedules/:id/:basename.:extension",
                    :path => ":rails_root/public/system/schedules/:id/:basename.:extension"
  validates_attachment_presence :file
  validates_presence_of :title
end
