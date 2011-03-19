class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :enrollment_id
      t.decimal :calculated_price, :precision => 8, :scale => 2
      t.date    :payment_date
      t.boolean :settled

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
