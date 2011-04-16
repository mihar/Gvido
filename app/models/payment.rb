class Payment < ActiveRecord::Base
  belongs_to  :enrollment
  has_one     :payment_exception
  has_one     :lesson, :dependent => :destroy
  
  scope :settled, where(:settled => true).order('payments.payment_date ASC')
  scope :unsettled, where(:settled => false)
  scope :regular, where(:payment_kind => 1..3)

  scope :due_this_month, where(:payment_date => Date.today.beginning_of_month..Date.today.end_of_month)
  scope :due, where("payment_date < ?", 1.day.from_now)
  
  PAYMENT_KIND = {
    :regular => 1,
    :half_prepayment_deducted => 2,
    :full_prepayment_deducted => 3,
    :prepayment => 4,
    :enrollment_fee => 5
  }
  
  # Returns a collection of all payment dates in hashes (keys are years, values are payable months)
  def self.all_payment_dates
    (self.find_by_sql("SELECT DISTINCT payment_date FROM payments ORDER BY payment_date ASC").map(&:payment_date)).group_by {|p| p.year}
  end
  
  def self.monthly_payments(payment_date)
    self.find_all_by_payment_date(payment_date)
  end
  
  def lessons_per_payment_period
    if enrollment.length % enrollment.payment_period == 0
      return enrollment.lessons_per_month * enrollment.payment_period
    else  
      if enrollment.payments.order('payments.payment_date ASC').last.id == id
        return (enrollment.length % enrollment.payment_period) * enrollment.lessons_per_month
      else
        return enrollment.lessons_per_month * enrollment.payment_period
      end
    end 
  end
end
