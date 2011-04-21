class AddCheckInDateToLessons < ActiveRecord::Migration
  def self.up
    add_column :lessons, :check_in_date, :date
  end

  def self.down
    remove_column :lessons, :check_in_date
  end
end
