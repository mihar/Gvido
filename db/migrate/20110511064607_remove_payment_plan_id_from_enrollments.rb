class RemovePaymentPlanIdFromEnrollments < ActiveRecord::Migration
  def self.up
    remove_column :enrollments, :payment_plan_id
  end

  def self.down
    add_column :enrollments, :payment_plan_id, :string
  end
end
