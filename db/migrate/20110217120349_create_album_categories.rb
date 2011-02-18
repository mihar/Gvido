class CreateAlbumCategories < ActiveRecord::Migration
  def self.up
    create_table :album_categories do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :album_categories
  end
end
