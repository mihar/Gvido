class CreateInvoices < ActiveRecord::Migration
  def self.up
    create_table :invoices do |t|
      t.integer :student_id
      t.string  :monthly_reference
      t.decimal :price, :precision => 8, :scale => 2, :default => 0
      t.date    :payment_date
      t.boolean :settled, :default => false
      t.string  :description

      t.timestamps
    end
  end

  def self.down
    drop_table :invoices
  end
end
