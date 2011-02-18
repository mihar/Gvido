class CreateInstrumentsMentors < ActiveRecord::Migration
  def self.up
    create_table :instruments_mentors, :id => false do |t|
      t.integer :instrument_id
      t.integer :mentor_id
    end
  end

  def self.down
    drop_table :instruments_mentors
  end
end
