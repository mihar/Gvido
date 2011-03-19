class CreateEnrollments < ActiveRecord::Migration
  def self.up
    create_table :enrollments do |t|
      t.integer :instrument_id
      t.integer :mentor_id
      t.integer :student_id
      t.date :enrollment_date
      t.date :cancel_date
      t.decimal :price_per_lesson, :precision => 8, :scale => 2
      t.decimal :prepayment, :precision => 8, :scale => 2, :default => 45
      t.integer :payment_period, :default => 1
      t.integer :lessons_per_month
      t.decimal :discount, :precision => 6, :scale => 4, :default => 0.0

      t.timestamps
    end
  end

  def self.down
    drop_table :enrollments
  end
end
