class AddPricePerLessonAndExpectedLessonsPerMonthToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :price_per_lesson, :decimal, :precision => 6, :scale => 4, :default => 0.0
  end

  def self.down
    remove_column :payments, :price_per_lesson
  end
end
