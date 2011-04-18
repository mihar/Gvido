class MentorHasOneUserInsteadOfBelongingToOne < ActiveRecord::Migration
  def self.up
    add_column :users, :mentor_id, :integer
    remove_column :mentors, :user_id
  end

  def self.down
    add_column :mentors, :user_id, :integer
    remove_column :users, :mentor_id
  end
end
