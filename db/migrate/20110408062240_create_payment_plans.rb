class CreatePaymentPlans < ActiveRecord::Migration
  def self.up
    create_table :payment_plans do |t|
      t.string  :title
      t.integer :payment_period
    end
  end

  def self.down
    drop_table :payment_plans
  end
end
