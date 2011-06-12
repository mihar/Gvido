class ProperAttributesForInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :payers_name, :string
    add_column :invoices, :payers_address, :string
    add_column :invoices, :recievers_name, :string
    add_column :invoices, :recievers_address, :string
  end

  def self.down
    remove_column :invoices, :recievers_address
    remove_column :invoices, :recievers_name
    remove_column :invoices, :payers_address
    remove_column :invoices, :payers_name
  end
end