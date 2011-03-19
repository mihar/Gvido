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
  it { should validate_numericality_of(:price_per_lesson) }
  it { should validate_numericality_of(:prepayment) }
  it { should validate_numericality_of(:discount) }
  
  
  it 'should create a payment for each month between enrollment_date and cancel_date' do
    #sep oct nov dec jan feb mar apr
    subject.payments.length.should eql(8)
  end
  
  it 'should have correct payment dates in created payments' do
    subject.payments[0].payment_date.should eql(Date.new(2011, 9, 1))
    subject.payments[1].payment_date.should eql(Date.new(2011, 10, 1))
    subject.payments[2].payment_date.should eql(Date.new(2011, 11, 1))
    subject.payments[3].payment_date.should eql(Date.new(2011, 12, 1))
    subject.payments[4].payment_date.should eql(Date.new(2012, 1, 1))
    subject.payments[5].payment_date.should eql(Date.new(2012, 2, 1))
    subject.payments[6].payment_date.should eql(Date.new(2012, 3, 1))
    subject.payments[7].payment_date.should eql(Date.new(2012, 4, 1))
  end
  
  it 'should deduct half of prepayment from first and last payment' do
    #price_per_lesson = 10
    #prepayment = 45/2 = 22.5
    #payment_period = 1
    #lessons_per_month = 5
    #tax = 20%
    #calculated_price = (10 * 5 - 22.5) * 1.2 = 33.0
    subject.payments[0].calculated_price.should eql( BigDecimal('33') )
    subject.payments[7].calculated_price.should eql( BigDecimal('33') )
  end
  
  it 'should not deduct half of prepayment from other payments' do
    #calculated_price = 10 * 5 * 1.2 = 60.0
    subject.payments[1].calculated_price.should eql( BigDecimal('60') )
    subject.payments[2].calculated_price.should eql( BigDecimal('60') )
    subject.payments[3].calculated_price.should eql( BigDecimal('60') )
    subject.payments[4].calculated_price.should eql( BigDecimal('60') )
    subject.payments[5].calculated_price.should eql( BigDecimal('60') )
    subject.payments[6].calculated_price.should eql( BigDecimal('60') )
  end
  
  it 'should calculate correct discount for first and last payment' do
   #discount = 5% = 0.05
   #calculated_price = ((10 * 5 - 22.5) - 0.05 * (10 * 5 - 22.5) ) * 1.2 = 31.35
    enrollment = Factory :enrollment, :discount => BigDecimal('0.05')
    
    puts " ???? izracunana vrednost = #{ enrollment.payments[0].calculated_price.to_s }"
    enrollment.payments[0].calculated_price.should eql( BigDecimal('31.35') )
    enrollment.payments[7].calculated_price.should eql( BigDecimal('31.35') )
  end
  
  it 'should create correct number of payments according to enrollments payment_period' do
    enrollment = Factory :enrollment, :payment_period => 3
    enrollment.payments.length.should eql(3)
  end
  
  it 'should create correct payment dates according to enrollments payment_period' do
    enrollment = Factory :enrollment, :payment_period => 3
    enrollment.payments[0].payment_date.should eql(Date.new(2011, 9, 1))
    enrollment.payments[1].payment_date.should eql(Date.new(2011, 12, 1))
    enrollment.payments[2].payment_date.should eql(Date.new(2012, 3, 1))
  end
  
  #it 'should calculate proper discount for first and last payment' do
  #  enrollment = Factory :enrollment, :payment_period => 3
  #  
  #end
  
  
end

