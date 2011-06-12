class ChangeLessonsPerMonthToNrOfLessonsInEnrollments < ActiveRecord::Migration
  def self.up
    rename_column :enrollments, :lessons_per_month, :nr_of_lessons
    remove_column :enrollments, :payment_period
  end

  def self.down
    rename_column :enrollments, :nr_of_lessons, :lessons_per_month
    add_column :enrollments, :payment_period, :integer
  end
end
