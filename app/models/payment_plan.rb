class PaymentPlan < ActiveRecord::Base
  has_many :enrollments
end
