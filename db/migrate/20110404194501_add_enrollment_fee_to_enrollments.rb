class AddEnrollmentFeeToEnrollments < ActiveRecord::Migration
  def self.up
    add_column :enrollments, :enrollment_fee, :decimal, :precision => 8, :scale => 2
  end

  def self.down
    remove_column :enrollments, :enrollment_fee
  end
end
