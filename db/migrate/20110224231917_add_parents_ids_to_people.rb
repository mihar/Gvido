class AddParentsIdsToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :mother_id, :integer
    add_column :people, :father_id, :integer
  end

  def self.down
    remove_column :people, :mother_id
    remove_column :people, :father_id
  end
end
