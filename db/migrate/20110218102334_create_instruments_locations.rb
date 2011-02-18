class CreateInstrumentsLocations < ActiveRecord::Migration
  def self.up
    create_table :instruments_locations, :id => false do |t|
      t.integer :instrument_id
      t.integer :location_id
    end
  end

  def self.down
    drop_table :instruments_locations
  end
end
