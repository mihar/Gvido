class Enrollment < ActiveRecord::Base  
  has_many :payments
  belongs_to :instrument
  belongs_to :mentor
  belongs_to :student
  validates_numericality_of :payment_period,    :only_integer => true, :greater_than_or_equal_to => 1
  validates_numericality_of :lessons_per_month, :only_integer => true, :greater_than_or_equal_to => 1
  validates_numericality_of :price_per_lesson,  :greater_than_or_equal_to => 0
  validates_numericality_of :prepayment,        :greater_than_or_equal_to => 0
  validates_numericality_of :discount,          :greater_than_or_equal_to => 0
  validates_presence_of :instrument_id, :mentor_id
  validate :cancel_date_correctness
  
  #after_validation :calculate_discount
  
  after_create  :create_payments
  after_update  :update_payments
  
  attr_accessor :billable_months
  
  def discount_percent
    "#{discount * 100}%".gsub(".", ",")
  end
  
  def discount_percent=(_discount)
    # 10%
    discount_without_percent = BigDecimal _discount.gsub("%", "").gsub(",", ".")
    
    self.discount = discount_without_percent / 100
  end
  
  private
  

  
  def create_payments
    set_billable_months
    create_new_payments
  end
  
  #destroys unsettled payments and creates new ones
  def update_payments
    set_billable_months
    @billable_months -= Payment.settled_payment_dates_for_enrollment(id)
    Payment.destroy_unsettled_payments_for_enrollment(id)
    create_new_payments
  end
  
  #creates a payment for every billable month
  def create_new_payments
    @billable_months.each do |payment_date|
      calculated_price = calculate_price
      if payment_date == @billable_months.first or payment_date == @billable_months.last
        calculated_price = calculate_price(true)
      end
      Payment.create do |p|
        p.enrollment_id = id
        p.payment_date = payment_date
        p.calculated_price = calculated_price
        p.settled = false
      end
    end
  end
  
  def set_billable_months
    start, stop = enrollment_date, cancel_date
    month_diff = stop.year == start.year ? stop.month - start.month : stop.month + (stop.year - start.year) * 12 - start.month
    
    #maps all months starting with enrollment_date and excluding cancel_date
    months = month_diff.times.map { |i| start >> i } 
    
    if payment_period > 1
      #gets first month in each payable period 
      @billable_months = months.in_groups_of(payment_period).map {|i| i[0] }
    else
      @billable_months = months
    end  
  end

  def calculate_discount
    self.discount = to_percent(discount)
  end
    
  def cancel_date_correctness
    errors.add :cancel_date, "Datum izpisa mora biti poznejši od datuma vpisa" if cancel_date < enrollment_date
  end
  
  def to_percent(percent_value)
    BigDecimal(percent_value.to_s)/BigDecimal('100')
  end
  
  
  #figure out what to do, when prepayment is higher then payment price
  def calculate_price(prepayment_cash_date = false)
    #((10 * 5 - 22.5) - 0.05 * (10 * 5 - 22.5) ) * 1.2 = 31.35
    puts "price_per_lesson #{price_per_lesson}"
    puts "lessons_per_month #{lessons_per_month}"
    puts "payment_period #{payment_period}"
    puts "discount #{discount}"
    
    calculus = price_per_lesson * lessons_per_month * payment_period
    puts "1  #{calculus}"
    if prepayment_cash_date
      calculus -= prepayment/BigDecimal('2')
      puts "2 #{calculus}"
    end
     
    calculus -= calculus * discount
    puts "3 #{calculus}"
    
    calculus = calculus * BigDecimal('1.2') #tax it up
    puts "4 #{calculus}"
    return calculus
  end
  
end

