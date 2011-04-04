class RenameLessonsPerMonthInLessons < ActiveRecord::Migration
  def self.up
    rename_column :lessons, :lessons_per_month, :hours_this_month
  end

  def self.down
    rename_column :lessons, :hours_this_month, :lessons_per_month
  end
end