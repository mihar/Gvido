class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string :title
      t.integer :position
      t.text :description
      t.integer :album_category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end
