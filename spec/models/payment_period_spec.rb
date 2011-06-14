require 'spec_helper'

describe PaymentPeriod do
  subject { Factory :payment_period }
  
  it { should be_valid }
  
  it { should belong_to :enrollment }
  it { should validate_numericality_of :discount }
  
  it "should create its monthly_lessons on creation" do
    #`puts subject.monthly_lessons.each {|i| puts "monthly_lesson";puts i.inspect; puts "invoice"; puts i.invoice.inspect }
    subject.monthly_lessons.should_not == []     
  end
  
  it "should have an error if the first payment period doesn't equal the enrollments start date" do
    payment_period = Factory.build :payment_period, :start_date => Date.new(2011, 8, 1)
    payment_period.should have(1).errors_on(:start_date)
  end
  
  it "should have an error if end_date is greater then enrollments cancel_date" do
    payment_period = Factory.build :payment_period, :end_date => Date.new(2012, 6, 2)
    payment_period.should have(1).errors_on(:end_date)
  end
  
  it "should have an error if start_date isn't equal to previous payment periods end date" do
    enr = Factory :enrollment
    pp1 = Factory.create :payment_period, :enrollment => enr, :start_date => Date.new(2011, 9, 1), :end_date => Date.new(2011, 11, 1)
    pp2 = Factory.build :payment_period,  :enrollment => enr, :start_date => Date.new(2011, 10, 1), :end_date => Date.new(2011, 12, 1)
    pp2.save
    pp2.should have(1).errors_on(:start_date)
  end
  
  it "should have an error if start_date isn't equal to previous payment periods end date" do
    enr = Factory :enrollment
    pp1 = Factory.create :payment_period, :enrollment => enr, :start_date => Date.new(2011, 9, 1), :end_date => Date.new(2011, 11, 1)
    pp2 = Factory.create :payment_period,  :enrollment => enr, :start_date => Date.new(2011, 11, 1), :end_date => Date.new(2012, 1, 1)
    pp3 = Factory.build :payment_period,  :enrollment => enr, :start_date => Date.new(2011, 12, 1), :end_date => Date.new(2012, 6, 1)
    pp3.should have(1).errors_on(:start_date)
  end
  
  it "should reject trimester payment plan on price_per_lesson enrollment" do
    enr = Factory :enrollment, :price_per_lesson => BigDecimal('20.0')
    pp  = Factory.build :payment_period, :enrollment => enr, :payment_plan_id => :trimester
    pp.save
    pp.should have(1).errors_on(:payment_plan_id)
  end
  
  it "should reject singular payment plan on price_per_lesson enrollment" do
    enr = Factory :enrollment, :price_per_lesson => BigDecimal('20.0')
    pp  = Factory.build :payment_period, :enrollment => enr, :payment_plan_id => :singular
    pp.should have(1).errors_on(:payment_plan_id)
  end
  
  it "should reject monthly payment plan on price_per_lesson enrollment" do
    enr = Factory :enrollment, :price_per_lesson => BigDecimal('20.0')
    pp  = Factory.build :payment_period, :enrollment => enr
    pp.should have(1).errors_on(:payment_plan_id)
  end
  
  it "should allow per_hour payment plan on price per lesson enrollment" do
    enr = Factory :enrollment, :price_per_lesson => BigDecimal('20.0')
    pp  = Factory.build :payment_period, :enrollment => enr, :payment_plan_id => :per_hour
    pp.should have(0).errors_on(:payment_plan_id)
  end
  
  context "with trimester payment plan" do
    it "should allow only september, december and march to be start dates" do
      pp = Factory.build :payment_period, :start_date => Date.new(2011, 10, 1), :payment_plan_id => :trimester
      pp.should have(2).errors_on(:start_date)
    end
    
    it "should allow only december, march and june to be end dates" do
      pp = Factory.build :payment_period, :end_date => Date.new(2011, 11, 1), :payment_plan_id => :trimester
      pp.should have(1).errors_on(:end_date)
    end
  end
  
  context "with singular payment plan" do
    it "should allow only september to june payment period" do
      pp = Factory.build :payment_period, :end_date => Date.new(2011, 11, 1), :payment_plan_id => :singular
      pp.should have(1).errors_on(:end_date)
    end
    
  end
  
  context "with monthly flat rate" do
    context "on a regular payment" do
      it "should calculate a correct payment" do
        #obrok = šolnina/število mesecev
        #obrok = 1000.0/9 = 111.111
        payments = Payment.create(subject)
        payments.first.price.should == BigDecimal('111.11')
        payments[1].price.should == BigDecimal('111.11')
        payments[2].price.should == BigDecimal('111.11')
        payments[3].price.should == BigDecimal('111.11')
        payments[4].price.should == BigDecimal('111.11')
        payments[5].price.should == BigDecimal('111.11')
        payments[6].price.should == BigDecimal('111.11')
        payments[7].price.should == BigDecimal('111.11')
        payments.last.price.should == BigDecimal('111.11')
      end
    end
    
    # it "should create nine invoices" do
    #   payment_period = Factory :payment_period
    #   payment_period.student.invoices.length.should == 9
    # end
    
    context "on prepayment deduction" do
      #obrok = šolnina/število mesecev - kavcija/2
      it "should calculate correct payments" do
        enrollment = Factory :enrollment, :prepayment => BigDecimal('40')
        payment_period = Factory :payment_period, :enrollment => enrollment
        #obrok = šolnina/število mesecev - 20 
        #obrok = 1000.0/9 -20 = 91.11
        payments = Payment.create(payment_period)
        payments.first.price.should == BigDecimal('91.11')
        payments[1].price.should == BigDecimal('111.11')
        payments[2].price.should == BigDecimal('111.11')
        payments[3].price.should == BigDecimal('111.11')
        payments[4].price.should == BigDecimal('111.11')
        payments[5].price.should == BigDecimal('111.11')
        payments[6].price.should == BigDecimal('111.11')
        payments[7].price.should == BigDecimal('111.11')
        payments.last.price.should == BigDecimal('91.11')
      end
    end
    
    context "on discounted enrollment" do
      #obrok = (šolnina - šolnina * popust)/število mesecev
      it "should calculate correct payments" do
        enrollment = Factory :enrollment, :discount => BigDecimal('0.05')
        payment_period = Factory :payment_period, :enrollment => enrollment
        #obrok = (šolnina - šolnina * popust)/število mesecev
        #obrok = (1000.0 - 1000 * 0.05)/9 = 105.55
        
        payments = Payment.create(payment_period)       
        payments.first.price.should == BigDecimal('105.55')
        payments[1].price.should == BigDecimal('105.55')
        payments[2].price.should == BigDecimal('105.55')
        payments[3].price.should == BigDecimal('105.55')
        payments[4].price.should == BigDecimal('105.55')
        payments[5].price.should == BigDecimal('105.55')
        payments[6].price.should == BigDecimal('105.55')
        payments[7].price.should == BigDecimal('105.55')
        payments.last.price.should == BigDecimal('105.55')
      end
    end
    
    context "on discounted enrollment with prepayment deduction" do
      #obrok = (šolnina - šolnina * popust)/število mesecev - kavcija/2
      it "should calculate correct payments" do
        enrollment = Factory :enrollment, :prepayment => BigDecimal('40'), :discount => BigDecimal('0.05')
        payment_period = Factory :payment_period, :enrollment => enrollment
        #obrok = (šolnina - šolnina * popust)/število mesecev - kavcija/2
        #obrok = (1000.0 - 1000 * 0.05)/9 -20 = 85.55
        
        payments = Payment.create(payment_period)     
        payments.first.price.should == BigDecimal('85.55')
        payments[1].price.should == BigDecimal('105.55')
        payments[2].price.should == BigDecimal('105.55')
        payments[3].price.should == BigDecimal('105.55')
        payments[4].price.should == BigDecimal('105.55')
        payments[5].price.should == BigDecimal('105.55')
        payments[6].price.should == BigDecimal('105.55')
        payments[7].price.should == BigDecimal('105.55')
        payments.last.price.should == BigDecimal('85.55')
      end
    end
    
    context "on discounted enrollment with prepayment deduction and payment deduction" do
      #obrok = (šolnina - šolnina * popust)/število mesecev - kavcija/2
      it "should calculate correct payments" do
        enrollment = Factory :enrollment, :prepayment => BigDecimal('40'), :discount => BigDecimal('0.05')
        payment_period = Factory :payment_period, :enrollment => enrollment, :discount => BigDecimal('0.05')
        #obrok = (šolnina - šolnina * popust)/število mesecev - kavcija/2
        #obrok = (1000.0 - 1000 * 0.05)/9 - ((1000.0 - 1000 * 0.05)/9 * 0.05) -20 = 80.27
        
        payments = Payment.create(payment_period)  
        payments.first.price.should == BigDecimal('80.27')
        payments[1].price.should == BigDecimal('100.27')
        payments[2].price.should == BigDecimal('100.27')
        payments[3].price.should == BigDecimal('100.27')
        payments[4].price.should == BigDecimal('100.27')
        payments[5].price.should == BigDecimal('100.27')
        payments[6].price.should == BigDecimal('100.27')
        payments[7].price.should == BigDecimal('100.27')
        payments.last.price.should == BigDecimal('80.27')
      end
    end
  end  

  context "with trimester falt rate" do
    context "on regular payment" do
      it "should calculate correct payments" do
        payment_period = Factory :payment_period, :payment_plan_id => :trimester
        #obrok = šolnina/število mesecev * 3
        #obrok = 1000/9 * 3 = 333.33
        
        payments = Payment.create(payment_period)     
        payments.first.price.should == BigDecimal('333.33')
        payments[1].price.should == BigDecimal('333.33')
        payments.last.price.should == BigDecimal('333.33')
        payments.count.should == 3
      end
      
      # it "should create three invoices" do
      #   payment_period = Factory :payment_period, :payment_plan_id => :trimester
      #   payment_period.student.invoices.length.should == 3
      # end
      
      # it "should create invoices with correct prices" do
      #   payment_period = Factory :payment_period, :payment_plan_id => :trimester
      #   
      #   payment_period.student.invoices[0].price.should  == BigDecimal('333.33')
      #   payment_period.student.invoices[1].price.should  == BigDecimal('333.33')
      #   payment_period.student.invoices[2].price.should  == BigDecimal('333.33')
      # end
    end
    
    context "with prepayment" do
      it "should calculate correct payments" do
        enrollment = Factory :enrollment, :prepayment => BigDecimal('40')
        payment_period = Factory :payment_period, :enrollment => enrollment, :payment_plan_id => :trimester
        #obrok = šolnina/število mesecev * 3 - kavcija/2 = 313.33
        #obrok = 1000/9 * 3 = 333.33
        
        payments = Payment.create(payment_period)  

        payments.count.should == 3
        payments.first.price.should == BigDecimal('313.33')
        payments[1].price.should == BigDecimal('333.33')
        payments.last.price.should == BigDecimal('313.33')
      end
    end
    
    context "with prepayment and enrollment discount" do
      it "should calculate correct payments" do
        enrollment = Factory :enrollment, :discount => BigDecimal('0.05'), :prepayment => BigDecimal('40')
        payment_period = Factory :payment_period, :enrollment => enrollment, :payment_plan_id => :trimester
        #obrok = (šolnina - šolnina * popust)/število mesecev * 3 - kavcija/2 = 296.66
        #obrok = (šolnina - šolnina * popust)/število mesecev * 3 = 316.66
        
        payments = Payment.create(payment_period)

        payments.count.should == 3
        payments.first.price.should == BigDecimal('296.66')
        payments[1].price.should == BigDecimal('316.66')
        payments.last.price.should == BigDecimal('296.66')
      end
    end
    
    context "with prepayment and enrollment discount and payment period discount" do
      it "should calculate correct payments" do
        enrollment = Factory :enrollment, :discount => BigDecimal('0.05'), :prepayment => BigDecimal('40')
        payment_period = Factory :payment_period, :enrollment => enrollment, :payment_plan_id => :trimester, :discount => BigDecimal('0.05')
        #obrok = ((šolnina - šolnina * popust)/število mesecev - (šolnina - šolnina * popust)/število mesecev * popust na obrok)  * 3 - kavcija/2 = 280.83
        #obrok = ((šolnina - šolnina * popust)/število mesecev - (šolnina - šolnina * popust)/število mesecev * popust na obrok)  * 3 = 300.83
        
        payments = Payment.create(payment_period)  

        payments.count.should == 3
        payments.first.price.should == BigDecimal('280.83')
        payments[1].price.should == BigDecimal('300.83')
        payments.last.price.should == BigDecimal('280.83')
      end
    end
  end
  
  context "with singular flat rate" do
    context "on regular payment" do
      # it "should create one invoices" do
      #   payment_period = Factory :payment_period, :payment_plan_id => :singular
      #   payment_period.student.invoices.length.should == 1
      # end
      
      it "should calculate correct payment" do
        payment_period = Factory :payment_period, :payment_plan_id => :singular
        #obrok = šolnina
        #obrok = 1000
        
        payments = Payment.create(payment_period)     
        payments.count.should == 1
        payments.first.price.should == BigDecimal('1000')
      end
    end
    
    context "with prepayment" do
      it "should calculate correct payment" do
        enrollment = Factory :enrollment, :prepayment => BigDecimal('40')
        payment_period = Factory :payment_period, :enrollment => enrollment, :payment_plan_id => :singular
        #obrok = šolnina - kavcija
        #obrok = 1000 - 40 = 960
        
        payments = Payment.create(payment_period)     
        payments.count.should == 1
        payments.first.price.should == BigDecimal('960')
      end
    end
    
    context "with prepayment and enrollment discount" do
      it "should calculate correct payment" do
        enrollment = Factory :enrollment, :discount => BigDecimal('0.05'), :prepayment => BigDecimal('40')
        payment_period = Factory :payment_period, :enrollment => enrollment, :payment_plan_id => :singular
        #obrok = (šolnina - šolnina * popust) - kavcija
        #obrok = 950 - 40 = 910
        
        payments = Payment.create(payment_period)     
        
        payments.count.should == 1
        payments.first.price.should == BigDecimal('910')
      end
    end
    
    context "with prepayment, enrollment discount and period discount" do
      it "should calculate correct payment" do
        enrollment = Factory :enrollment, :discount => BigDecimal('0.05'), :prepayment => BigDecimal('40')
        payment_period = Factory :payment_period, :enrollment => enrollment, :payment_plan_id => :singular, :discount => BigDecimal('0.05')
        #obrok = (šolnina - šolnina * popust) - (šolnina - šolnina * popust) * popust na obrok - kavcija
        #obrok = 862.5
        
        payments = Payment.create(payment_period)
        
        payments.count.should == 1
        payments.first.price.should == BigDecimal('862.5')
      end
    end
  end

  context "with hourly payment" do
    it "should calculate correct payments" do
      enrollment = Factory :enrollment, :price_per_lesson => BigDecimal('20')
    end
  end
  
end
