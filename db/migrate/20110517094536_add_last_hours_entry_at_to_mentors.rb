class AddLastHoursEntryAtToMentors < ActiveRecord::Migration
  def self.up
    add_column :mentors, :last_hours_entry_at, :datetime
  end

  def self.down
    remove_column :mentors, :last_hours_entry_at
  end
end
