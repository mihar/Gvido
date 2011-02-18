class CreateContactsInstruments < ActiveRecord::Migration
  def self.up
    create_table :contacts_instruments, :id => false do |t|
      t.integer :instrument_id
      t.integer :contact_id
    end
  end

  def self.down
    drop_table :contacts_instruments
  end
end
