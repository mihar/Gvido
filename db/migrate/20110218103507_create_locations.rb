class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :title
      t.string :address
      t.string :city
      t.integer :zip
      t.float :lat
      t.float :lang
      t.integer :location_section_id
      t.string :subtitle
      t.text :about
      t.string :uri

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
