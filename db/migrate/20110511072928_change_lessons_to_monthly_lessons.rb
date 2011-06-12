class ChangeLessonsToMonthlyLessons < ActiveRecord::Migration
  def self.up
    drop_table :lessons
    
    create_table :monthly_lessons do |t|
      t.integer :mentor_id
      t.integer :student_id
      t.integer :enrollment_id
      t.integer :payment_period_id
      t.integer :invoice_id
      t.integer :hours, :default => 0
      t.date    :date
      t.timestamps
    end
  end

  def self.down
    drop_table :monthly_lessons
    
    create_table "lessons", :force => true do |t|
      t.integer  "hours_this_month", :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "mentor_id"
      t.integer  "student_id"
      t.date     "check_in_date"
    end
  end
end
