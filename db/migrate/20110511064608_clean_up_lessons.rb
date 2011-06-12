class CleanUpLessons < ActiveRecord::Migration
  def self.up
    remove_column :lessons, :payment_id
    remove_column :lessons, :expected_hours_this_month
  end

  def self.down
    add_column :lessons, :payment_id, :integer
    add_column :lessons, :expected_hours_this_month, :integer, :default => 0
  end
end
