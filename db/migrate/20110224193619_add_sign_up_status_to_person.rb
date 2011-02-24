class AddSignUpStatusToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :sign_up_status, :integer
  end

  def self.down
    remove_column :people, :sign_up_status
  end
end
