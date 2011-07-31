class AddReferentToMentors < ActiveRecord::Migration
  def self.up
    add_column :mentors, :referent, :boolean, :default => false
  end

  def self.down
    remove_column :mentors, :referent
  end
end
