class AddExpectedHoursThisMonthToLessons < ActiveRecord::Migration
  def self.up
    add_column :lessons, :expected_hours_this_month, :integer, :default => 0
  end

  def self.down
    remove_column :lessons, :expected_hours_this_month
  end
end
