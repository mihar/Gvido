class AddPaymentTypeIdToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :payment_kind, :integer, :default => 1
  end

  def self.down
    remove_column :payments, :payment_kind
  end
end
