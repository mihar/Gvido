class AlbumCategory < ActiveRecord::Base
  default_scope order(:position)
  has_many :albums
end
