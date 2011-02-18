class AlbumCategory < ActiveRecord::Base
  has_many :albums
end
