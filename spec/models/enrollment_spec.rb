require 'spec_helper'

describe Enrollment do
  subject do 
    enrollment = Factory.build :enrollment
    enrollment.save
    enrollment
  end
  
  it {
    unless subject.errors.empty?
      puts '-- Napake pri shranjevanju --'
      puts subject.errors.inspect
    end
    should be_valid
  }
  it { should validate_presence_of(:instrument_id) }
  it { should validate_presence_of(:mentor_id) }
  it { should belong_to(:instrument) }
  it { should belong_to(:mentor) }
  it { should belong_to(:student) }
  it { should validate_numericality_of(:lessons_per_month) }
  it { should validate_numericality_of(:total_price) }
  it { should validate_numericality_of(:prepayment) }
  it { should validate_numericality_of(:discount) }
  
  ### enrollment with no prepayment and no enrollment_fee
  it 'should create a payment for each month between enrollment_date and cancel_date' do
    #sep oct nov dec jan feb mar apr < may
    subject.payments.length.should eql(8)
  end
  
  it 'should have correct payment dates in created payments' do
    subject.payments[0].payment_date.should eql(Date.new(2011, 9,  20))
    subject.payments[1].payment_date.should eql(Date.new(2011, 10, 20))
    subject.payments[2].payment_date.should eql(Date.new(2011, 11, 20))
    subject.payments[3].payment_date.should eql(Date.new(2011, 12, 20))
    subject.payments[4].payment_date.should eql(Date.new(2012, 1,  20))
    subject.payments[5].payment_date.should eql(Date.new(2012, 2,  20))
    subject.payments[6].payment_date.should eql(Date.new(2012, 3,  20))
    subject.payments[7].payment_date.should eql(Date.new(2012, 4,  20))
  end
  
  it 'should calculate correct prices' do
    #calculated_price = 500/8 = 62.5
    subject.payments[0].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[1].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[2].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[3].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[4].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[5].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[6].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[7].calculated_price.should eql( BigDecimal('62.5') )
  end
  
  ### enrollment with discount and prepayment
  it 'should calculate correct discount for payments other than prepayment' do
    #prepayment deducted price = (500/8 - 22.5) - 0.05 * (500/8 - 22.5) = 40 - 2 = 38
    #regulary deducted price = 500/8 - 0.05 * 500/8 = 59.375 == 59.38
    enrollment = Factory :discounted_enrollment
    
    enrollment.payments[0].calculated_price.should eql( BigDecimal('45') )
    enrollment.payments[0].payment_kind.should eql(Payment::PAYMENT_KIND[:prepayment])
    enrollment.payments[1].calculated_price.should eql( BigDecimal('38') )
    enrollment.payments[2].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments[3].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments[4].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments[5].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments[6].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments[7].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments[8].calculated_price.should eql( BigDecimal('38') )
  end
  
  ### enrollment with prepayment and no enrollment fee
  it 'should create 9 payments including prepayment' do
    #sep oct nov dec jan feb mar apr < may
    enrollment = Factory :prepayed_enrollment
    enrollment.payments.length.should eql(9)
  end
  
  it 'should have correct payment dates in created payments' do
    enrollment = Factory :prepayed_enrollment

    enrollment.payments[1].payment_date.should eql(Date.new(2011, 9,  20))
    enrollment.payments[2].payment_date.should eql(Date.new(2011, 10, 20))
    enrollment.payments[3].payment_date.should eql(Date.new(2011, 11, 20))
    enrollment.payments[4].payment_date.should eql(Date.new(2011, 12, 20))
    enrollment.payments[5].payment_date.should eql(Date.new(2012, 1,  20))
    enrollment.payments[6].payment_date.should eql(Date.new(2012, 2,  20))
    enrollment.payments[7].payment_date.should eql(Date.new(2012, 3,  20))
    enrollment.payments[8].payment_date.should eql(Date.new(2012, 4,  20))
  end
  
  it 'should calculate correct payments' do
    #regular payments = 500/8 = 62.5
    #prepayment deducted payments = 500/8 - 45/2 = 40
    enrollment = Factory :prepayed_enrollment
    enrollment.payments[0].calculated_price.should eql( BigDecimal('45') )
    enrollment.payments[1].calculated_price.should eql( BigDecimal('40') )
    enrollment.payments[2].calculated_price.should eql( BigDecimal('62.5') )
    enrollment.payments[3].calculated_price.should eql( BigDecimal('62.5') )
    enrollment.payments[4].calculated_price.should eql( BigDecimal('62.5') )
    enrollment.payments[5].calculated_price.should eql( BigDecimal('62.5') )
    enrollment.payments[6].calculated_price.should eql( BigDecimal('62.5') )
    enrollment.payments[7].calculated_price.should eql( BigDecimal('62.5') )
    enrollment.payments[8].calculated_price.should eql( BigDecimal('40') )
  end
    
  ### three months per payment enrollment creation with prepayment
  it 'should create correct number of payments for three month payment plan' do
    enrollment = Factory :three_pay_period_enrollment
    enrollment.payments.length.should eql(4)
  end
  
  it 'should create correct payment dates according to enrollments payment_period' do
    enrollment = Factory :three_pay_period_enrollment

    enrollment.payments[1].payment_date.should eql(Date.new(2011, 9,  20))
    enrollment.payments[2].payment_date.should eql(Date.new(2011, 12, 20))
    enrollment.payments[3].payment_date.should eql(Date.new(2012, 3,  20))
  end

  it 'should calculate correct prices for three_pay_period_enrollment payments' do
    #prepayment deducted price = 500/3 - 22.5 = 144.166666 == 144.17
    #regular price = 500/3 = 166.666666 == 166.67
    enrollment = Factory :three_pay_period_enrollment
    enrollment.payments[0].calculated_price.should eql( BigDecimal('45') )
    enrollment.payments[1].calculated_price.should eql( BigDecimal('144.17') )
    enrollment.payments[2].calculated_price.should eql( BigDecimal('166.67') )
    enrollment.payments[3].calculated_price.should eql( BigDecimal('144.17') )
  end
  
  ### three months per payment enrollment creation with discount and prepayment
  it 'should calculate correct prices for three_pay_period_enrollment payments with discount' do
    #prepayment deducted price = (500/3 - 22.5) - 0.05 * (500/3 - 22.5) = 136.9583334 == 136.96
    #regular price = 500/3 - 0.05 * 500/3 = 166.666667 - 8.3333333333 = 158.3333333 == 158.33
    
    enrollment = Factory :discounted_three_pay_period_enrollment
    enrollment.payments[0].calculated_price.should eql( BigDecimal('45') )
    enrollment.payments[1].calculated_price.should eql( BigDecimal('136.96') )
    enrollment.payments[2].calculated_price.should eql( BigDecimal('158.33') )
    enrollment.payments[3].calculated_price.should eql( BigDecimal('136.96') )
  end
  
  ### single payment enrollment creation with prepayment
  it 'should create two payments' do
    enrollment = Factory :single_payment_enrollment
    enrollment.payments.length.should eql(2)
  end
  
  it 'should create correct payment dates for single payment enrollment' do
    enrollment = Factory :single_payment_enrollment
    
    enrollment.payments[1].payment_date.should eql(Date.new(2011, 9,  20))
  end
  
  it 'should deduct the whole prepament on single payment enrollment' do
    enrollment = Factory :single_payment_enrollment
    enrollment.payments[0].calculated_price.should eql(BigDecimal('45.0'))
    enrollment.payments[1].calculated_price.should eql(BigDecimal('455.0'))
  end
  
  ### updated enrollment with no prepayment and no enrollment_fee 
  it '(update) should create 8 payments' do
    subject.save
    subject.payments.length.should eql(8)
  end
  
  it '(update) should have correct payment dates in created payments' do
    subject.save
    subject.payments[0].payment_date.should eql(Date.new(2011, 9,  20))
    subject.payments[1].payment_date.should eql(Date.new(2011, 10, 20))
    subject.payments[2].payment_date.should eql(Date.new(2011, 11, 20))
    subject.payments[3].payment_date.should eql(Date.new(2011, 12, 20))
    subject.payments[4].payment_date.should eql(Date.new(2012, 1,  20))
    subject.payments[5].payment_date.should eql(Date.new(2012, 2,  20))
    subject.payments[6].payment_date.should eql(Date.new(2012, 3,  20))
    subject.payments[7].payment_date.should eql(Date.new(2012, 4,  20))
  end
  
  it '(update) should calculate correct prices' do
    #calculated_price = 500/8 = 62.5
    subject.save
    subject.payments[0].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[1].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[2].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[3].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[4].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[5].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[6].calculated_price.should eql( BigDecimal('62.5') )
    subject.payments[7].calculated_price.should eql( BigDecimal('62.5') )
  end
  
  ### updated enrollment with prepayment and no enrollment fee
  it '(update) should create 9 payments including prepayment' do
    #sep oct nov dec jan feb mar apr < may
    enrollment = Factory :prepayed_enrollment
    enrollment.save
    enrollment.payments(true).length.should eql(9)
  end

  it '(update) should have correct payment dates in created payments' do
    enrollment = Factory :prepayed_enrollment
    enrollment.save

    enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
    enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
    enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
    enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
    enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))
    enrollment.payments(true)[6].payment_date.should eql(Date.new(2012, 2,  20))
    enrollment.payments(true)[7].payment_date.should eql(Date.new(2012, 3,  20))
    enrollment.payments(true)[8].payment_date.should eql(Date.new(2012, 4,  20))
  end

  it '(update) should calculate correct payments' do
   #regular payments = 500/8 = 62.5
   #prepayment deducted payments = 500/8 - 45/2 = 40
   enrollment = Factory :prepayed_enrollment
   enrollment.save
   enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
   enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('40') )
   enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('62.5') )
   enrollment.payments(true)[3].calculated_price.should eql( BigDecimal('62.5') )
   enrollment.payments(true)[4].calculated_price.should eql( BigDecimal('62.5') )
   enrollment.payments(true)[5].calculated_price.should eql( BigDecimal('62.5') )
   enrollment.payments(true)[6].calculated_price.should eql( BigDecimal('62.5') )
   enrollment.payments(true)[7].calculated_price.should eql( BigDecimal('62.5') )
   enrollment.payments(true)[8].calculated_price.should eql( BigDecimal('40') )
  end
  
  ### updated discounted enrollment with prepayment and no enrollment fee
  it '(update) should calculate correct prices for discounted enrollment' do
    #calculated_price = (500/8 - 22.5) - 0.05 * (500/8 - 22.5) = 40 - 2 = 38
    enrollment = Factory :discounted_enrollment
    enrollment.save
    enrollment.payments(true).length.should eql(9)
    enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
    enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('38') )
    enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments(true)[3].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments(true)[4].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments(true)[5].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments(true)[6].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments(true)[7].calculated_price.should eql( BigDecimal('59.38') )
    enrollment.payments(true)[8].calculated_price.should eql( BigDecimal('38') )
  end

  ### monthly payment plan update with enrollment lenght change
  it '(update - enrollment lenght cut) should create correct payments' do
    #calculated_price = 500/5 - 22.5 = 77.5
    subject.cancel_date = Date.new(2012, 2, 1)
    subject.save
    
    subject.payments(true).length.should eql(5)
    
    subject.payments(true)[0].payment_date.should eql(Date.new(2011, 9,  20))
    subject.payments(true)[1].payment_date.should eql(Date.new(2011, 10, 20))
    subject.payments(true)[2].payment_date.should eql(Date.new(2011, 11, 20))
    subject.payments(true)[3].payment_date.should eql(Date.new(2011, 12, 20))
    subject.payments(true)[4].payment_date.should eql(Date.new(2012, 1,  20))
    
    subject.payments(true)[0].calculated_price.should eql( BigDecimal('100') )
    subject.payments(true)[1].calculated_price.should eql( BigDecimal('100') )
    subject.payments(true)[2].calculated_price.should eql( BigDecimal('100') )
    subject.payments(true)[3].calculated_price.should eql( BigDecimal('100') )
    subject.payments(true)[4].calculated_price.should eql( BigDecimal('100') )
  end

  it '(update - discounted enrollment lenght cut) should create correct payments' do
    #calculated_price = (500/5 - 22.5) - 0.05 * (500/5 - 22.5) = 77.5 - 3.875 = 73.63
    enrollment = Factory :discounted_enrollment
    enrollment.cancel_date = Date.new(2012, 2, 1)
    enrollment.save
    enrollment.payments(true).length.should eql(6)
    
    enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
    enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
    enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
    enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
    enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))
    
    enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
    enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('73.63') )
    enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('95') )
    enrollment.payments(true)[3].calculated_price.should eql( BigDecimal('95') )
    enrollment.payments(true)[4].calculated_price.should eql( BigDecimal('95') )
    enrollment.payments(true)[5].calculated_price.should eql( BigDecimal('73.63') )
  end

  ### monthly payment plan update with prepayment and enrollment lenght change
  it '(update - enrollment lenght cut) should create correct payments' do
    #calculated_price = 500/5 - 22.5 = 77.5
    enrollment = Factory :prepayed_enrollment
    enrollment.cancel_date = Date.new(2012, 2, 1)
    enrollment.save

    enrollment.payments(true).length.should eql(6)

    enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
    enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
    enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
    enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
    enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))

    enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
    enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('77.5') )
    enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('100') )
    enrollment.payments(true)[3].calculated_price.should eql( BigDecimal('100') )
    enrollment.payments(true)[4].calculated_price.should eql( BigDecimal('100') )
    enrollment.payments(true)[5].calculated_price.should eql( BigDecimal('77.5') )
  end
  
  
  ### updated enrollment, length cut, first payment settled (no prepayment, no enrollment fee)
  it '(update - settled payment, length cut) should create correct payments' do
    subject.payments[0].settled = true
    subject.payments[0].save
    subject.cancel_date = Date.new(2012, 2, 1)
    subject.save
    
    subject.payments(true).length.should eql(5)
    
    subject.payments(true)[0].payment_date.should eql(Date.new(2011, 9,  20))
    subject.payments(true)[1].payment_date.should eql(Date.new(2011, 10, 20))
    subject.payments(true)[2].payment_date.should eql(Date.new(2011, 11, 20))
    subject.payments(true)[3].payment_date.should eql(Date.new(2011, 12, 20))
    subject.payments(true)[4].payment_date.should eql(Date.new(2012, 1,  20))

    #first one is settled, stays the same
    subject.payments(true)[0].calculated_price.should eql( BigDecimal('62.5') )
    #(500 - 62.5) /4 = 109.38
    subject.payments(true)[1].calculated_price.should eql( BigDecimal('109.38') )
    subject.payments(true)[2].calculated_price.should eql( BigDecimal('109.38') )
    subject.payments(true)[3].calculated_price.should eql( BigDecimal('109.38') )
    subject.payments(true)[4].calculated_price.should eql( BigDecimal('109.38') )
  end
  
  ### updated enrollment, length cut, first two payments settled with prepayment, no enrollment fee
  it '(update - settled payment, length cut, with prepayment) should create correct payments' do
    enrollment = Factory :prepayed_enrollment
    enrollment.payments[1].settled = true
    enrollment.payments[2].settled = true
    enrollment.payments[1].save
    enrollment.payments[2].save

    enrollment.cancel_date = Date.new(2012, 2, 1)
    enrollment.save
    
    enrollment.payments(true).length.should eql(6)
    
    enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
    enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
    enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
    enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
    enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))
    
    #(500 - 102.5 - 22.5) /3 = 125
    #125 - 22.5 = 102.5
    enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
    enrollment.payments(true)[0].payment_kind.should eql(Payment::PAYMENT_KIND[:prepayment])
    
    enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('40') )
    enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
    
    enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('62.5') )
    enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
    
    enrollment.payments(true)[3].calculated_price.should eql( BigDecimal('125') )
    enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
    
    enrollment.payments(true)[4].calculated_price.should eql( BigDecimal('125') )
    enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
    
    enrollment.payments(true)[5].calculated_price.should eql( BigDecimal('102.5') )
    enrollment.payments(true)[5].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
  end
  
  ###updated enrollment with trimester and prepayment, first payment settled then length cut
  it "should calculate corect prices for updated enrollment with trimester, prepayment and length cut" do
    enrollment = Factory :three_pay_period_enrollment
    enrollment.payments[1].settled = true
    enrollment.payments[1].save

    enrollment.cancel_date = Date.new(2012, 2, 1)
    enrollment.save
    
    enrollment.payments(true).length.should eql(3)
    
    #(500 - 144.17 - 22.5) - 22.5
    enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
    enrollment.payments(true)[0].payment_kind.should eql(Payment::PAYMENT_KIND[:prepayment])
    
    enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('144.17') )
    enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
    
    enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('310.83') )
    enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
  end 
  
  it "shouldn't change anyhing if single payment enrollment has its payment settled after length cut" do
    enrollment = Factory :single_payment_enrollment
    enrollment.payments[1].settled = true
    enrollment.payments[1].save

    enrollment.cancel_date = Date.new(2012, 2, 1)
    enrollment.save
    
    enrollment.payments(true).length.should eql(2)
    
    #(500 - 144.17 - 22.5) - 22.5
    enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
    enrollment.payments(true)[0].payment_kind.should eql(Payment::PAYMENT_KIND[:prepayment])
    
    enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('455') )
    enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:full_prepayment_deducted])
   
  end
  
end

