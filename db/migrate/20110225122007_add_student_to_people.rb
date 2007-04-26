class AddStudentToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :student, :boolean, :default => false
  end

  def self.down
    remove_column :people, :student
  end
end
