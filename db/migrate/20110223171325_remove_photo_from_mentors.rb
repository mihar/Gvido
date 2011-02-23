class RemovePhotoFromMentors < ActiveRecord::Migration
  def self.up
    remove_column :mentors, :photo
  end

  def self.down
    add_column :mentors, :photo, :string
  end
end
