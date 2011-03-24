class AddDeletedToEnrollments < ActiveRecord::Migration
  def self.up
    add_column :enrollments, :deleted, :boolean, :default => false
  end

  def self.down
    remove_column :enrollments, :deleted
  end
end
