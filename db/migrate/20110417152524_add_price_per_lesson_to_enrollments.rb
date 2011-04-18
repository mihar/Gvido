class AddPricePerLessonToEnrollments < ActiveRecord::Migration
  def self.up
    add_column :enrollments, :price_per_lesson, :decimal, :precision => 6, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :enrollments, :price_per_lesson
  end
end
