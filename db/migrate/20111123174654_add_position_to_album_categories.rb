class AddPositionToAlbumCategories < ActiveRecord::Migration
  def self.up
    add_column :album_categories, :position, :integer
  end

  def self.down
    remove_column :album_categories, :position
  end
end
