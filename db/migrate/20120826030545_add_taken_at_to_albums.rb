class AddTakenAtToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :taken_at, :date
  end
end
