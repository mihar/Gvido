class AddUserIdToMentors < ActiveRecord::Migration
  def self.up
    add_column :mentors, :user_id, :integer
  end

  def self.down
    remove_column :mentors, :user_id
  end
end
