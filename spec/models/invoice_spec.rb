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
      
      invoice = Invoice.new_on_date(Date.new(2011, 9, 20)).first
      
      invoice.payment_date.should == Date.new(2011, 9, 20) 
      invoice.price.should == BigDecimal('111.11')
      invoice.payers_name.should == student.full_name
      invoice.payers_address.should ==  student.full_address
      invoice.recievers_name.should == Invoice::RECIEVERS_NAME
      invoice.recievers_address.should == Invoice::RECIEVERS_ADDRESS
    end
    
    it "should add three euros to invoice price when student is late with payment" do
      
    end
  end
end
