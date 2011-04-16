class ChangeDefaultValuesInEnrollmentsTable < ActiveRecord::Migration
  def self.up
    change_column :enrollments, :prepayment,      :decimal, :precision => 8, :scale => 2, :default => 0.0
    change_column :enrollments, :enrollment_fee,  :decimal, :precision => 8, :scale => 2, :default => 0.0 
  end

  def self.down
    change_column :enrollments, :prepayment,      :decimal, :precision => 8, :scale => 2, :default => 45.0
    change_column :enrollments, :enrollment_fee,  :decimal, :precision => 8, :scale => 2
  end
end
