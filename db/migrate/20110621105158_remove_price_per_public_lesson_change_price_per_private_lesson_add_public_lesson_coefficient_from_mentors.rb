class RemovePricePerPublicLessonChangePricePerPrivateLessonAddPublicLessonCoefficientFromMentors < ActiveRecord::Migration
  def self.up
    remove_column :mentors, :price_per_private_lesson
    remove_column :mentors, :price_per_public_lesson
    
    add_column :mentors, :price_per_private_lesson, :decimal, :precision => 8, :scale => 2, :default => 0.0
    add_column :mentors, :public_lesson_coefficient, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end

  def self.down
    remove_column :mentors, :price_per_private_lesson
    remove_column :mentors, :public_lesson_coefficient
    
    add_column :mentors, :price_per_private_lesson, :decimal, :precision => 10, :scale => 0
    add_column :mentors, :price_per_public_lesson, :decimal, :precision => 10, :scale => 0
  end
end
