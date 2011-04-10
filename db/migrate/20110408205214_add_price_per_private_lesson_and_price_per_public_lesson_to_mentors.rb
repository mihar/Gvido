class AddPricePerPrivateLessonAndPricePerPublicLessonToMentors < ActiveRecord::Migration
  def self.up
    add_column :mentors, :price_per_private_lesson, :decimal
    add_column :mentors, :price_per_public_lesson, :decimal
  end

  def self.down
    remove_column :mentors, :price_per_public_lesson
    remove_column :mentors, :price_per_private_lesson
  end
end
