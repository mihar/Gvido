class ChangeDefaultValuesInEnrollmentsTable < ActiveRecord::Migration
  def self.up
    change_column :enrollments, :prepayment,      :decimal, :default => 0.0
    change_column :enrollments, :enrollment_fee,  :decimal, :default => 0.0
  end

  def self.down
    change_column :enrollments, :prepayment,      :decimal
    change_column :enrollments, :enrollment_fee,  :decimal
  end
end
