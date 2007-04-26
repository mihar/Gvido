class AddDateOfBirthToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :date_of_birth, :date
  end

  def self.down
    remove_column :people, :date_of_birth
  end
end
