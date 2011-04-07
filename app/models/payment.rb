class Payment < ActiveRecord::Base
  belongs_to  :enrollment
  has_one     :payment_exception
  has_one     :lesson, :dependent => :destroy
  
  scope :settled, where(:settled => true)
  scope :unsettled, where(:settled => false)
  scope :due_this_month, where(:payment_date => Date.today.beginning_of_month..Date.today.end_of_month)
  scope :due, where("payment_date < ?", 1.day.from_now)
  
  # Returns a collection of all payment dates in hashes (keys are years, values are payable months)
  def self.all_payment_dates
    (self.find_by_sql("SELECT DISTINCT payment_date FROM payments ORDER BY payment_date ASC").map(&:payment_date)).group_by {|p| p.year}
  end
  
  def self.monthly_payments(payment_date)
    self.find_all_by_payment_date(payment_date)
  end
  
end
