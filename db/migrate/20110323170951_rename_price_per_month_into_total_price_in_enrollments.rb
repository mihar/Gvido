class RenamePricePerMonthIntoTotalPriceInEnrollments < ActiveRecord::Migration
  def self.up
    rename_column :enrollments, :price_per_lesson, :total_price
  end

  def self.down
    rename_column :enrollments, :total_price, :price_per_lesson
  end
end
