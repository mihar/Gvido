class AddProcessedToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :processed, :boolean, :default => false
  end

  def self.down
    remove_column :contacts, :processed
  end
end
