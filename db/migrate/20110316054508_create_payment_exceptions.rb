class CreatePaymentExceptions < ActiveRecord::Migration
  def self.up
    create_table :payment_exceptions do |t|
      t.integer :payment_id
      t.date    :payment_date
      t.integer :lessons_per_month
      t.decimal :discount, :precision => 6, :scale => 4, :default => 0.0

      t.timestamps
    end
  end

  def self.down
    drop_table :payment_exceptions
  end
end
