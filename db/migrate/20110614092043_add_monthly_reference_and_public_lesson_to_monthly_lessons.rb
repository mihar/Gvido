class AddMonthlyReferenceAndPublicLessonToMonthlyLessons < ActiveRecord::Migration
  def self.up
    add_column :monthly_lessons, :monthly_reference, :string
    add_column :monthly_lessons, :public_lesson, :boolean, :default => false
  end

  def self.down
    remove_column :monthly_lessons, :monthly_reference
    remove_column :monthly_lessons, :public_lesson
  end
end
