class RemoveUselessAttributesFromMonthlyLessons < ActiveRecord::Migration
  def self.up
    remove_column :monthly_lessons, :invoice_id
    remove_column :monthly_lessons, :monthly_reference
  end

  def self.down
    add_column :monthly_lessons, :invoice_id, :integer
    add_column :monthly_lessons, :monthly_reference, :string
  end
end
