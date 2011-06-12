class AddPublicChecksToMentors < ActiveRecord::Migration
  def self.up
    add_column :mentors, :public_email, :boolean, :default => false
    add_column :mentors, :public_phone, :boolean, :default => false
    add_column :mentors, :public_address, :boolean, :default => false
  end

  def self.down
    remove_column :mentors, :public_address
    remove_column :mentors, :public_phone
    remove_column :mentors, :public_email
  end
end
