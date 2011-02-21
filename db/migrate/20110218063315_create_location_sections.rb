class CreateLocationSections < ActiveRecord::Migration
  def self.up
    create_table :location_sections do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :location_sections
  end
end
