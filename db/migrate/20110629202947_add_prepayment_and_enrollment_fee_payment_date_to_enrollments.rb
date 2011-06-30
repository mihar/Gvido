class AddPrepaymentAndEnrollmentFeePaymentDateToEnrollments < ActiveRecord::Migration
  def self.up
    add_column :enrollments, :prepayment_payment_date, :date
    add_column :enrollments, :enrollment_fee_payment_date, :date
  end

  def self.down
    remove_column :enrollments, :enrollment_fee_payment_date
    remove_column :enrollments, :prepayment_payment_date
  end
end
