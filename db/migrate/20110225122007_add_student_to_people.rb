class AddStudentToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :student, :boolean
  end

  def self.down
    remove_column :people, :student
  end
end
