class CreatePaymentPeriods < ActiveRecord::Migration
  def self.up
    create_table :payment_periods do |t|
      t.integer :enrollment_id
      t.string :payment_plan_id
      t.date :start_date
      t.date :end_date
      t.decimal :discount, :precision => 7, :scale => 4, :default => 0.0
      t.boolean :deduct_prepayment, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_periods
  end
end