class CreateLocationsMentorsJoinTable < ActiveRecord::Migration
  def self.up
    create_table :locations_mentors, :id => false, :force => true do |t|
      t.integer :location_id
      t.integer :mentor_id
      
    end
  end

  def self.down
    drop_table :locations_mentors, :id => false
  end
end