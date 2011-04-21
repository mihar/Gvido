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
  

  context "with total price" do
    
    context "and monthly payment plan" do
      context "on create" do
        it 'should create a payment for each month between enrollment_date and cancel_date' do
          #sep oct nov dec jan feb mar apr < may
          subject.payments.length.should eql(8)
        end

        it 'should have correct payment dates in created payments' do
          subject.payments(true)[0].payment_date.should eql(Date.new(2011, 9,  20))
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
      end

      context "on update with no changes" do
        it 'should create 8 payments' do
          subject.save
          subject.payments.length.should eql(8)
        end

        it 'should have correct payment dates in created payments' do
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

        it 'should calculate correct prices' do
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
      end

      context "on update with enrollment length cut" do
        it 'should create correct payments' do
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
      end

      context "on update with first payment settled and enrollment length cut" do
        it 'should create correct payments' do
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
      end
    end

    context ", monthly payment plan and prepayment" do
      context "on create" do
        it 'should create 9 payments including prepayment' do
          #sep oct nov dec jan feb mar apr < may
          enrollment = Factory :prepayed_enrollment
          enrollment.payments(true).length.should eql(9)
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
      end

      context "on update with no changes" do
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
      end

      context "on update with enrollment length cut" do
        it 'should create correct payments' do
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

      end

      context "on update with enrollment length cut and first two payments settled" do
        it 'should create correct payments' do
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
      end
    end

    context ", monthly payment plan, prepayment and discount" do
      context "on create" do
        it 'should calculate correct price for payments' do
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
      end

      context "on update with no changes" do
        it 'should calculate correct price for payments' do
          #prepayment deducted price = (500/8 - 22.5) - 0.05 * (500/8 - 22.5) = 40 - 2 = 38
          #regulary deducted price = 500/8 - 0.05 * 500/8 = 59.375 == 59.38
          enrollment = Factory :discounted_enrollment
          enrollment.save

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
      end

      context "on update with enrollment length cut" do
        it 'should create correct payments' do
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
      end

      context "on update with first payment settled and enrollment length cut" do
        it 'should create correct payments' do
          #prepayment deducted price = (500/8 - 22.5) - 0.05 * (500/8 - 22.5) = 40 - 2 = 38

          #regular price after length cut = (500 - 38 - 22.5)/4 - 0.05 * (500 - 38 - 22.5)/4 = 104.38
          #prepayment deducted price = (500 - 38 - 22.5)/4 - 22.5 - 0.05 * ((500 - 38 - 22.5)/4 - 22.5)
          enrollment = Factory :discounted_enrollment
          enrollment.payments[1].settled = true
          enrollment.payments[1].save

          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save
          enrollment.payments(true).length.should eql(6)

          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))

          enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
          enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('38') )

          enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('104.38') )
          enrollment.payments(true)[3].calculated_price.should eql( BigDecimal('104.38') )
          enrollment.payments(true)[4].calculated_price.should eql( BigDecimal('104.38') )
          enrollment.payments(true)[5].calculated_price.should eql( BigDecimal('83.01') )
        end
      end
    end

    context ", trimester payment plan and prepayment" do
      context "on create" do
        it 'should create correct payments' do
          enrollment = Factory :three_pay_period_enrollment
          enrollment.payments(true).length.should eql(4)
          enrollment.payments[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments[2].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments[3].payment_date.should eql(Date.new(2012, 3,  20))

          enrollment.payments[0].calculated_price.should eql( BigDecimal('45') )
          enrollment.payments[1].calculated_price.should eql( BigDecimal('144.17') )
          enrollment.payments[2].calculated_price.should eql( BigDecimal('166.67') )
          enrollment.payments[3].calculated_price.should eql( BigDecimal('144.17') )        
        end
      end

      context "on update with no changes" do
        it 'should create correct payments' do
          enrollment = Factory :three_pay_period_enrollment
          enrollment.save

          enrollment.payments(true).length.should eql(4)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2012, 3,  20))
          enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
          enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('144.17') )
          enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('166.67') )
          enrollment.payments(true)[3].calculated_price.should eql( BigDecimal('144.17') )        
        end
      end

      context "on update with enrollment length cut" do
        it 'should create correct payments' do
          enrollment = Factory :three_pay_period_enrollment
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save
          enrollment.payments(true).length.should eql(3)
          #deducts prepayment in both payments
          #500 / 2 - 22.5 = 
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 12, 20))

          enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
          enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('227.5') )
          enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('227.5') )        
        end
      end

      context "on update with first payment settled and enrollment length cut" do
        it "should create correct payments" do
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
      end
    end

    context ", trimester payment plan, prepayment and discount" do
      context "on create" do
        it 'should calculate correct payments' do
          #prepayment deducted price = (500/3 - 22.5) - 0.05 * (500/3 - 22.5) = 136.9583334 == 136.96
          #regular price = 500/3 - 0.05 * 500/3 = 166.666667 - 8.3333333333 = 158.3333333 == 158.33
          enrollment = Factory :discounted_three_pay_period_enrollment

          enrollment.payments(true).length.should eql(4)
          enrollment.payments[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments[2].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments[3].payment_date.should eql(Date.new(2012, 3,  20))

          enrollment.payments[0].calculated_price.should eql( BigDecimal('45') )
          enrollment.payments[1].calculated_price.should eql( BigDecimal('136.96') )
          enrollment.payments[2].calculated_price.should eql( BigDecimal('158.33') )
          enrollment.payments[3].calculated_price.should eql( BigDecimal('136.96') )
        end
      end

      context "on update with no changes" do
        it 'should calculate correct payments' do
          #prepayment deducted price = (500/3 - 22.5) - 0.05 * (500/3 - 22.5) = 136.9583334 == 136.96
          #regular price = 500/3 - 0.05 * 500/3 = 166.666667 - 8.3333333333 = 158.3333333 == 158.33
          enrollment = Factory :discounted_three_pay_period_enrollment
          enrollment.save

          enrollment.payments(true).length.should eql(4)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2012, 3,  20))

          enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
          enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('136.96') )
          enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('158.33') )
          enrollment.payments(true)[3].calculated_price.should eql( BigDecimal('136.96') )
        end
      end

      context "on update with length cut" do
        it 'should calculate correct payments' do
          #prepayment deducted price = (500/2 - 22.5) - 0.05 * (500/2 - 22.5) = 216.13
          enrollment = Factory :discounted_three_pay_period_enrollment
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save

          enrollment.payments(true).length.should eql(3)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 12, 20))

          enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
          enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('216.13') )
          enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('216.13') )
        end
      end

      context "on update with first payment settled and length cut" do
        it 'should calculate correct payments' do
          #1st prepayment deducted price = (500/3 - 22.5) - 0.05 * (500/3 - 22.5) = 136.9583334 == 136.96
          #2nd prepayment deducted price = (500 - 136.96 - 22.5) - 22.5 - 0.05 * (500 - 136.96 - 22.5 - 22.5) = 302.138 == 302.14
          enrollment = Factory :discounted_three_pay_period_enrollment
          enrollment.payments[1].settled = true
          enrollment.payments[1].save

          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save

          enrollment.payments(true).length.should eql(3)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 12, 20))

          enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
          enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('136.96') )
          enrollment.payments(true)[2].calculated_price.should eql( BigDecimal('302.14') )
        end
      end
    end  

    context ", singular payment plan and prepayment" do
      context "on create" do
        it 'should create correct payments' do
          enrollment = Factory :single_payment_enrollment
          enrollment.payments(true).length.should eql(2)
          enrollment.payments[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments[0].calculated_price.should eql(BigDecimal('45.0'))
          enrollment.payments[1].calculated_price.should eql(BigDecimal('455.0'))        
        end
      end

      context "on update with no changes" do
        it 'should create correct payments' do
          enrollment = Factory :single_payment_enrollment
          enrollment.save
          enrollment.payments(true).length.should eql(2)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[0].calculated_price.should eql(BigDecimal('45.0'))
          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('455.0'))        
        end
      end

      context "on update with enrollment length cut" do
        it 'should create correct payments' do
          enrollment = Factory :single_payment_enrollment
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save
          enrollment.payments(true).length.should eql(2)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[0].calculated_price.should eql(BigDecimal('45.0'))
          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('455.0'))        
        end
      end

      context "on update with settled payment" do
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
    end
  end
  
  context "with price per lesson" do
    
    context "and monthly payment plan" do
      context "on create" do
        it "should create correct payments" do
          enrollment = Factory :enrollment_with_price_per_lesson
          #regular price = 25*5 = 125
          
          enrollment.payments(true).length.should eql(8)
          enrollment.payments(true)[0].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2012, 1,  20))
          enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 2,  20))
          enrollment.payments(true)[6].payment_date.should eql(Date.new(2012, 3,  20))
          enrollment.payments(true)[7].payment_date.should eql(Date.new(2012, 4,  20))  
          
          enrollment.payments(true)[0].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[5].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[6].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[7].calculated_price.should eql(BigDecimal('125'))

          enrollment.payments(true)[0].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[5].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[6].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[7].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
        end
      end
      
      context "on update with no changes" do
        it "should create correct payments" do
          enrollment = Factory :enrollment_with_price_per_lesson
          enrollment.save
        
          #regular price = 25*5 = 125
          enrollment.payments(true).length.should eql(8)
          enrollment.payments(true)[0].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2012, 1,  20))
          enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 2,  20))
          enrollment.payments(true)[6].payment_date.should eql(Date.new(2012, 3,  20))
          enrollment.payments(true)[7].payment_date.should eql(Date.new(2012, 4,  20))  
        
          enrollment.payments(true)[0].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[5].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[6].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[7].calculated_price.should eql(BigDecimal('125'))

          enrollment.payments(true)[0].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[5].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[6].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[7].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
        end
      end
      
      context "on update with enrollment length cut" do
        it "should create correct payments" do
          enrollment = Factory :enrollment_with_price_per_lesson
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save
          
          #regular price = 25*5 = 125
          enrollment.payments(true).length.should eql(5)
          enrollment.payments(true)[0].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2012, 1,  20))
        
          enrollment.payments(true)[0].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('125'))

          enrollment.payments(true)[0].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
        end
      end
      
      context "on update with first payment settled and enrollment length cut" do
        it "should create correct payments" do
          enrollment = Factory :enrollment_with_price_per_lesson
          enrollment.payments(true)[0].settled = true
          enrollment.payments(true)[0].save
          
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save
          
          #regular price = 25*5 = 125
          enrollment.payments(true).length.should eql(5)
          enrollment.payments(true)[0].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2012, 1,  20))
        
          enrollment.payments(true)[0].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('125'))

          enrollment.payments(true)[0].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
        end
      end
    end
    
    context ", monthly payment plan and prepayment" do
      context "on create" do
        it "should create correct payments" do
          enrollment = Factory :prepayed_enrollment_with_price_per_lesson

          enrollment.payments(true).length.should eql(9)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))
          enrollment.payments(true)[6].payment_date.should eql(Date.new(2012, 2,  20))
          enrollment.payments(true)[7].payment_date.should eql(Date.new(2012, 3,  20))
          enrollment.payments(true)[8].payment_date.should eql(Date.new(2012, 4,  20))  

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('102.5'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[5].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[6].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[7].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[8].calculated_price.should eql(BigDecimal('102.5'))

          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[5].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[6].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[7].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[8].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
        end
      end
      
      context "on update with no changes" do
        it "should create correct payments" do
          enrollment = Factory :prepayed_enrollment_with_price_per_lesson
          enrollment.save

          enrollment.payments(true).length.should eql(9)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))
          enrollment.payments(true)[6].payment_date.should eql(Date.new(2012, 2,  20))
          enrollment.payments(true)[7].payment_date.should eql(Date.new(2012, 3,  20))
          enrollment.payments(true)[8].payment_date.should eql(Date.new(2012, 4,  20))  

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('102.5'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[5].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[6].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[7].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[8].calculated_price.should eql(BigDecimal('102.5'))

          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[5].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[6].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[7].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[8].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
        end
      end
      
      context "on update with enrollment length cut" do
        it "should create correct payments" do
          enrollment = Factory :prepayed_enrollment_with_price_per_lesson
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save

          enrollment.payments(true).length.should eql(6)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('102.5'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[5].calculated_price.should eql(BigDecimal('102.5'))

          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[5].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
        end
      end
      
      context "on update with first payment settled and enrollment lenght cut" do
        it "should create correct payments" do
          enrollment = Factory :prepayed_enrollment_with_price_per_lesson
          enrollment.payments(true)[1].settled = true
          enrollment.payments[1].save
          
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save

          enrollment.payments(true).length.should eql(6)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('102.5'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('125'))
          enrollment.payments(true)[5].calculated_price.should eql(BigDecimal('102.5'))

          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[5].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
        end
      
        it "should calcuate correct total price" do
          enrollment = Factory :prepayed_enrollment_with_price_per_lesson
          enrollment.payments(true)[1].settled = true
          enrollment.payments[1].save
          
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save
          
          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('102.5'))
          enrollment.total_price.should == enrollment.payments(true).map(&:calculated_price).sum
        end
      end
    end
    
    context ", monthly payment plan, prepayment and discount" do
      context "on create" do
        it "should create correct payments" do
          enrollment = Factory :prepayed_enrollment_with_price_per_lesson_and_discount
          #25 * 5 - 0.05 * 25 * 5 = 118.75
          #(25 * 5 -22.5) - 0.05 * (25 * 5 -22.5) = 97.375
          enrollment.payments(true).length.should eql(9)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))
          enrollment.payments(true)[6].payment_date.should eql(Date.new(2012, 2,  20))
          enrollment.payments(true)[7].payment_date.should eql(Date.new(2012, 3,  20))
          enrollment.payments(true)[8].payment_date.should eql(Date.new(2012, 4,  20))  

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('97.38'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[5].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[6].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[7].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[8].calculated_price.should eql(BigDecimal('97.38'))

          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[5].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[6].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[7].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[8].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
        end
      end
      
      context "on update with no changes" do
        it "should create correct payments" do
          enrollment = Factory :prepayed_enrollment_with_price_per_lesson_and_discount
          enrollment.save
          #25 * 5 - 0.05 * 25 * 5 = 118.75
          #(25 * 5 -22.5) - 0.05 * (25 * 5 -22.5) = 97.375
          enrollment.payments(true).length.should eql(9)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))
          enrollment.payments(true)[6].payment_date.should eql(Date.new(2012, 2,  20))
          enrollment.payments(true)[7].payment_date.should eql(Date.new(2012, 3,  20))
          enrollment.payments(true)[8].payment_date.should eql(Date.new(2012, 4,  20))  

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('97.38'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[5].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[6].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[7].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[8].calculated_price.should eql(BigDecimal('97.38'))

          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[5].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[6].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[7].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[8].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          
        end
      end
      
      context "on update with enrollment length cut" do
        it "should create correct payments" do
          enrollment = Factory :prepayed_enrollment_with_price_per_lesson_and_discount
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save
          #25 * 5 - 0.05 * 25 * 5 = 118.75
          #(25 * 5 -22.5) - 0.05 * (25 * 5 -22.5) = 97.375
          enrollment.payments(true).length.should eql(6)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('97.38'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[5].calculated_price.should eql(BigDecimal('97.38'))

          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[5].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
        end
      end
      
      context "on update with first payment settled and enrollment length cut" do
        it "should create correct payments" do
          enrollment = Factory :prepayed_enrollment_with_price_per_lesson_and_discount
          enrollment.payments(true)[1].settled = true
          enrollment.payments[1].save
          
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save
          #25 * 5 - 0.05 * 25 * 5 = 118.75
          #(25 * 5 -22.5) - 0.05 * (25 * 5 -22.5) = 97.375
          enrollment.payments(true).length.should eql(6)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 10, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2011, 11, 20))
          enrollment.payments(true)[4].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[5].payment_date.should eql(Date.new(2012, 1,  20))

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('97.38'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[4].calculated_price.should eql(BigDecimal('118.75'))
          enrollment.payments(true)[5].calculated_price.should eql(BigDecimal('97.38'))

          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[4].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[5].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
        end
      end
    end
    
    context ", trimester payment plan and prepayment" do
      context "on create" do
        it "should create correct payments" do
          enrollment = Factory :trimester_enrollment_with_prepayment  
          #25 * 5 * 3 = 375
          #375 - 22.5 = 352.5
          #25 * 5 * 2 - 22.5= 250
          
          enrollment.payments(true).length.should eql(4)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2012, 3,  20))

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('352.5'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('375'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('227.5'))
          
          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
        end
      end
      
      context "on update with no changes" do
        it "should create correct payments" do
          enrollment = Factory :trimester_enrollment_with_prepayment
          enrollment.save
          #25 * 5 * 3 = 375
          #375 - 22.5 = 352.5
          #25 * 5 * 2 - 22.5= 227.5
          
          enrollment.payments(true).length.should eql(4)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 12, 20))
          enrollment.payments(true)[3].payment_date.should eql(Date.new(2012, 3,  20))

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('352.5'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('375'))
          enrollment.payments(true)[3].calculated_price.should eql(BigDecimal('227.5'))
          
          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:regular])
          enrollment.payments(true)[3].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
        end
      end
      
      context "on update with enrollment length cut" do
        it "should create correct payments" do
          enrollment = Factory :trimester_enrollment_with_prepayment
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save

          #25 * 5 * 3 - 22.5 = 352.5
          #25 * 5 * 2 - 22.5= 227.5
          
          enrollment.payments(true).length.should eql(3)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 12, 20))

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('352.5'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('227.5'))
          
          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
        end
      end
      
      context "on update with first payment settled and enrollment lenght cut" do
        it "should create correct payments" do
          enrollment = Factory :trimester_enrollment_with_prepayment
          enrollment.payments(true)[1].settled = true
          enrollment.payments[1].save
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save

          #25 * 5 * 3 - 22.5 = 352.5
          #25 * 5 * 2 - 22.5= 227.5
          
          enrollment.payments(true).length.should eql(3)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[2].payment_date.should eql(Date.new(2011, 12, 20))

          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('352.5'))
          enrollment.payments(true)[2].calculated_price.should eql(BigDecimal('227.5'))
          
          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
          enrollment.payments(true)[2].payment_kind.should eql(Payment::PAYMENT_KIND[:half_prepayment_deducted])
        end
      end
    end
    
    context ", singular payment plan and prepayment" do
      context "on create" do
        it 'should create correct payments' do
          enrollment = Factory :prepayed_singular_enrollment_with_price_per_lesson
          enrollment.payments(true).length.should eql(2)
          enrollment.payments[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments[0].calculated_price.should eql(BigDecimal('45.0'))
          enrollment.payments[1].calculated_price.should eql(BigDecimal('955'))        
        end
      end

      context "on update with no changes" do
        it 'should create correct payments' do
          enrollment = Factory :prepayed_singular_enrollment_with_price_per_lesson
          enrollment.save
          enrollment.payments(true).length.should eql(2)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[0].calculated_price.should eql(BigDecimal('45.0'))
          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('955'))        
        end
      end

      context "on update with enrollment length cut" do
        it 'should create correct payments' do
          #25*5*5 -45 = 580
          enrollment = Factory :prepayed_singular_enrollment_with_price_per_lesson
          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save
          enrollment.payments(true).length.should eql(2)
          enrollment.payments(true)[1].payment_date.should eql(Date.new(2011, 9,  20))
          enrollment.payments(true)[0].calculated_price.should eql(BigDecimal('45.0'))
          enrollment.payments(true)[1].calculated_price.should eql(BigDecimal('580'))        
        end
      end

      context "on update with settled payment" do
        it "shouldn't change anyhing if single payment enrollment has its payment settled after length cut" do
          enrollment = Factory :prepayed_singular_enrollment_with_price_per_lesson
          enrollment.payments(true)[1].settled = true
          enrollment.payments[1].save

          enrollment.cancel_date = Date.new(2012, 2, 1)
          enrollment.save

          enrollment.payments(true).length.should eql(2)

          #(500 - 144.17 - 22.5) - 22.5
          enrollment.payments(true)[0].calculated_price.should eql( BigDecimal('45') )
          enrollment.payments(true)[0].payment_kind.should eql(Payment::PAYMENT_KIND[:prepayment])

          enrollment.payments(true)[1].calculated_price.should eql( BigDecimal('955') )
          enrollment.payments(true)[1].payment_kind.should eql(Payment::PAYMENT_KIND[:full_prepayment_deducted])
        end
      end
    end
  end
  
  context "on lesson creation" do
    it "should create correct lessons for monthly enrollment" do
      counter = 0
      subject.payments(true).each do |payment|
        payment.payment_kind.should == Payment::PAYMENT_KIND[:regular]
        payment.lessons.length.should == 1
        payment.lessons.first.expected_hours_this_month.should == 5
        payment.lessons.first.check_in_date.should == ((Date.new(2011, 9, 1)) >> counter ).at_end_of_month
        
        counter += 1
      end
    end
    
    it "should create correct lessons for trimester enrollment" do
      enrollment = Factory :three_pay_period_enrollment
      
      counter = 0
      enrollment.payments(true).each do |payment|
        counter += 1
        
        case counter 
        when 1
          payment.payment_kind.should == Payment::PAYMENT_KIND[:prepayment]
          payment.lessons.empty?.should == true
        when 2 
          payment.payment_kind.should == Payment::PAYMENT_KIND[:half_prepayment_deducted]
          payment.lessons.length.should == 3
          
          payment.lessons[0].check_in_date.should == Date.new(2011, 9, 30)
          payment.lessons[1].check_in_date.should == Date.new(2011, 10, 31)
          payment.lessons[2].check_in_date.should == Date.new(2011, 11, 30)
          payment.lessons[0].expected_hours_this_month.should == 5
          payment.lessons[1].expected_hours_this_month.should == 5
          payment.lessons[2].expected_hours_this_month.should == 5
        when 3
          payment.lessons.length.should == 3
          payment.payment_kind.should == Payment::PAYMENT_KIND[:regular]
          payment.lessons[0].check_in_date.should == Date.new(2011, 12, 31)
          payment.lessons[1].check_in_date.should == Date.new(2012, 1, 31)
          payment.lessons[2].check_in_date.should == Date.new(2012, 2, 29)
          payment.lessons[0].expected_hours_this_month.should == 5
          payment.lessons[1].expected_hours_this_month.should == 5
          payment.lessons[2].expected_hours_this_month.should == 5
        when 4
          payment.payment_kind.should == Payment::PAYMENT_KIND[:half_prepayment_deducted]
          payment.lessons.length.should == 2
          payment.lessons[0].check_in_date.should == Date.new(2012, 3, 31)
          payment.lessons[1].check_in_date.should == Date.new(2012, 4, 30)
          payment.lessons[0].expected_hours_this_month.should == 5
          payment.lessons[1].expected_hours_this_month.should == 5
        end 
        
      end
    end
    
    it "shold create correct lessons for singular enrollment" do
      enrollment = Factory :single_payment_enrollment
      
      counter = 0
      enrollment.payments(true).each do |payment|
        counter += 1
        
        case counter 
        when 1
          payment.payment_kind.should == Payment::PAYMENT_KIND[:prepayment]
          payment.lessons.empty?.should == true
        when 2 
          payment.payment_kind.should == Payment::PAYMENT_KIND[:full_prepayment_deducted]
          payment.lessons.length.should == 8
          
          payment.lessons[0].check_in_date.should == Date.new(2011, 9, 30)
          payment.lessons[1].check_in_date.should == Date.new(2011, 10, 31)
          payment.lessons[2].check_in_date.should == Date.new(2011, 11, 30)
          payment.lessons[3].check_in_date.should == Date.new(2011, 12, 31)
          payment.lessons[4].check_in_date.should == Date.new(2012, 1, 31)
          payment.lessons[5].check_in_date.should == Date.new(2012, 2, 29)
          payment.lessons[6].check_in_date.should == Date.new(2012, 3, 31)
          payment.lessons[7].check_in_date.should == Date.new(2012, 4, 30)
          payment.lessons[0].expected_hours_this_month.should == 5
          payment.lessons[1].expected_hours_this_month.should == 5
          payment.lessons[2].expected_hours_this_month.should == 5
          payment.lessons[3].expected_hours_this_month.should == 5
          payment.lessons[4].expected_hours_this_month.should == 5
          payment.lessons[5].expected_hours_this_month.should == 5
          payment.lessons[6].expected_hours_this_month.should == 5
          payment.lessons[7].expected_hours_this_month.should == 5
        end
      end 
    end          
  end
end