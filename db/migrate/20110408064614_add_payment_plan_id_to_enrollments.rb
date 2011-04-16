class AddPaymentPlanIdToEnrollments < ActiveRecord::Migration
  def self.up
    add_column :enrollments, :payment_plan_id, :string
  end

  def self.down
    remove_column :enrollments, :payment_plan_id
  end
end
