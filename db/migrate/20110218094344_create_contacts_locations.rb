class CreateContactsLocations < ActiveRecord::Migration
  def self.up
    create_table :contacts_locations, :id => false do |t|
      t.integer :contact_id
      t.integer :location_id
    end
  end

  def self.down
    drop_table :contacts_locations
  end
end
