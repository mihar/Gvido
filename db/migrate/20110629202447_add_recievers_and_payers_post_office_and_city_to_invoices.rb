class AddRecieversAndPayersPostOfficeAndCityToInvoices < ActiveRecord::Migration
  def self.up
    add_column :invoices, :recievers_post_office_and_city, :string
    add_column :invoices, :payers_post_office_and_city, :string
  end

  def self.down
    remove_column :invoices, :payers_post_office_and_city
    remove_column :invoices, :recievers_post_office_and_city
  end
end
