class Banner < ActiveRecord::Base
  attr_accessible :url, :image
  has_attached_file :image
end
