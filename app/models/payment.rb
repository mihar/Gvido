class Payment < ActiveRecord::Base
  belongs_to  :enrollment
  has_one     :payment_exception
  has_one     :lesson
 
  def self.settled_payments(enrollment_id)
    where("enrollment_id = ? AND settled = ?", enrollment_id, true)
  end
  
  def self.unsettled_payments(enrollment_id)
    where("enrollment_id = ? AND settled = ?", enrollment_id, false)
  end
  
  def self.settled_payment_dates_for_enrollment(enrollment_id)
    settled_payments(enrollment_id).map &:payment_date
  end
  
  def self.destroy_unsettled_payments_for_enrollment(enrollment_id)
    unsettled_payments(enrollment_id).destroy_all
  end
  
  #returns a collection of all payment dates in hashes (keys are years, values are payable months)
  def self.all_payment_dates
    (self.find_by_sql("SELECT DISTINCT payment_date FROM payments ORDER BY payment_date ASC").map(&:payment_date)).group_by {|p| p.year}
  end
  
  def self.monthly_payments(payment_date)
    self.find_all_by_payment_date(payment_date)
  end
  
end
