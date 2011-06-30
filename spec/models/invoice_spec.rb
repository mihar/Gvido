require 'spec_helper'

describe Invoice do
  subject { Factory :invoice }
  
  it { should be_valid }
  it { should belong_to :student }

  context "concerning invoice price calculations" do
    it "should return correct calculations for created enrollments" do
      student = Factory :student
      enrollment = Factory :enrollment, :student => student
      payment_period = Factory :payment_period, :enrollment => enrollment
      
      invoice = Invoice.new_on_date(Date.new(2011, 9, 20), Date.new(2011, 9, 20)).first
      
      invoice.monthly_reference.should == "8091112-#{student.reference_number}"
      invoice.payment_date.should == Date.new(2011, 9, 20) 
      invoice.price.should == BigDecimal('111.11')
      invoice.payers_name.should == student.full_name
      invoice.payers_address.should ==  student.full_address
      invoice.recievers_name.should == Invoice::RECIEVERS_NAME
      invoice.recievers_address.should == Invoice::RECIEVERS_ADDRESS
    end
    
    it "should add three euros to invoice price for each month when student is late with payment" do
      student = Factory :student
      enrollment = Factory :enrollment, :student => student
      payment_period = Factory :payment_period, :enrollment => enrollment
      
      invoice = Invoice.new_on_date(Date.new(2011, 9, 20), Date.new(2011, 10, 20)).first
      invoice.payment_date.should == Date.new(2011, 9, 20) 
      invoice.price.should == BigDecimal('114.11')
    end
    
    it "should add three euros to invoice price for each month when student is late with payment" do
      student = Factory :student
      enrollment = Factory :enrollment, :student => student
      payment_period = Factory :payment_period, :enrollment => enrollment
      
      invoice = Invoice.new_on_date(Date.new(2011, 9, 20), Date.new(2011, 11, 20)).first
      invoice.payment_date.should == Date.new(2011, 9, 20) 
      invoice.price.should == BigDecimal('117.11')
    end
    
    it "should create new invoice for enrollment fee and prepayment on given month" do
      student = Factory :student
      enrollment = Factory :enrollment, :student => student, 
        :enrollment_fee_payment_date => Date.new(2011, 1, 1), :enrollment_fee => BigDecimal('50'),
        :prepayment_payment_date => Date.new(2011, 1, 1), :prepayment => BigDecimal('50')
      payment_period = Factory :payment_period, :enrollment => enrollment
      
      Invoice.new_on_date(Date.new(2011, 1, 1), Date.today).should have(2).invoices
    end
    
    it "should properly calculate per hour payment plan"
    
    it "should properly calculate per hour payment plan with more then one monthly lesson"
    
    it "post_office and place should be decoupled from both addresses, payers and recievers for easier styling" do
      subject.should respond_to(:recievers_address)
      subject.should respond_to(:recievers_post_office_and_city)
      subject.should respond_to(:payers_address)
      subject.should respond_to(:payers_post_office_and_city)
    end
  end
end
