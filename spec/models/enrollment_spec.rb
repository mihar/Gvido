require 'spec_helper'

describe Enrollment do
  subject { Factory :enrollment }
  
  it { should be_valid }
  it { should validate_presence_of(:instrument_id) }
  it { should validate_presence_of(:mentor_id) }
  it { should belong_to(:instrument) }
  it { should belong_to(:mentor) }
  it { should belong_to(:student) }
  it { should validate_numericality_of(:payment_period) }
  it { should validate_numericality_of(:lessons_per_month) }
  it { should validate_numericality_of(:total_price) }
  it { should validate_numericality_of(:prepayment) }
  it { should validate_numericality_of(:discount) }
  
  
  it 'should create a payment for each month between enrollment_date and cancel_date' do
    #sep oct nov dec jan feb mar apr
    subject.payments.length.should eql(8)
  end
  
  it 'should have correct payment dates in created payments' do
    subject.payments[0].payment_date.should eql(Date.new(2011, 9, 15))
    subject.payments[1].payment_date.should eql(Date.new(2011, 10, 15))
    subject.payments[2].payment_date.should eql(Date.new(2011, 11, 15))
    subject.payments[3].payment_date.should eql(Date.new(2011, 12, 15))
    subject.payments[4].payment_date.should eql(Date.new(2012, 1, 15))
    subject.payments[5].payment_date.should eql(Date.new(2012, 2, 15))
    subject.payments[6].payment_date.should eql(Date.new(2012, 3, 15))
    subject.payments[7].payment_date.should eql(Date.new(2012, 4, 15))
  end
  
  it 'should deduct half of prepayment from first and last payment' do
    #calculated_price = 500/8 - 22.5 = 40
    subject.payments[0].calculated_price.should eql( BigDecimal('40') )
    subject.payments[7].calculated_price.should eql( BigDecimal('40') )
  end
  
  it 'should not deduct half of prepayment from payments that are not first or last' do
    #calculated_price = 500/8 = 62.5
    subject.payments[1].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[2].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[3].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[4].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[5].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[6].calculated_price.should eql( BigDecimal('62.5') )
  end
  
  it 'should calculate correct discount for first and last payment' do
    #calculated_price = (500/8 - 22.5) - 0.05 * (500/8 - 22.5) = 40 - 2 = 38
    enrollment = Factory :discounted_enrollment
    
    enrollment.payments[0].calculated_price.should eql( BigDecimal('38') )
    enrollment.payments[7].calculated_price.should eql( BigDecimal('38') )
  end
  
  it 'should calculate correct discount for payments other than first or last' do
    #calculated_price = 500/8 - 0.05 * 500/8 = 62.5 - 3.125 = 59.375 == 59.38
    enrollment = Factory :discounted_enrollment
    
    enrollment.payments[1].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments[2].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments[3].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments[4].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments[5].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments[6].calculated_price.should eql( BigDecimal('59.38') )
  end
  
  it 'should create correct number of payments according to enrollments payment_period' do
    enrollment = Factory :three_pay_period_enrollment
    enrollment.payments.length.should eql(3)
  end
  
  it 'should create correct payment dates according to enrollments payment_period' do
    enrollment = Factory :three_pay_period_enrollment
    enrollment.payments[0].payment_date.should eql(Date.new(2011, 9, 15))
    enrollment.payments[1].payment_date.should eql(Date.new(2011, 12, 15))
    enrollment.payments[2].payment_date.should eql(Date.new(2012, 3, 15))
  end
  
  it 'should deduct half of prepayment from first and last payment from three_pay_period_enrollment' do
    #calculated_price = 500/3 - 22.5 = 144.166666 == 144.17
    enrollment = Factory :three_pay_period_enrollment
    enrollment.payments[0].calculated_price.should eql( BigDecimal('144.17') )
    enrollment.payments[2].calculated_price.should eql( BigDecimal('144.17') )
  end
  
  it 'should not deduct half of prepayment from payment between first and last from three_pay_period_enrollment' do
    #calculated_price = 500/3 = 166.666666 = zaokrozeno 166.67
    enrollment = Factory :three_pay_period_enrollment
    enrollment.payments[1].calculated_price.should eql( BigDecimal('166.67') )
  end
  
  it 'should calculate the right discounted value for first and last payment from discounted_three_pay_period_enrollment' do
    #calculated_price = (500/3 - 22.5) - 0.05 * (500/3 - 22.5) = 144.1666667 - 7.20833333 = 136.9583334 == 136.96
    enrollment = Factory :discounted_three_pay_period_enrollment
    enrollment.payments[0].calculated_price.should eql( BigDecimal('136.96') )
    enrollment.payments[2].calculated_price.should eql( BigDecimal('136.96') )
  end
  
  it 'should calculate the right discounted value for payment between first and last from three_pay_period_enrollment' do
    #calculated_price = 500/3 - 0.05 * 500/3 = 166.666667 - 8.3333333333 = 158.3333333 == 158.33
    enrollment = Factory :discounted_three_pay_period_enrollment
    enrollment.payments[1].calculated_price.should eql( BigDecimal('158.33') )
  end
  
end

