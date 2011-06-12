require 'spec_helper'

describe Invoice do
  subject { Factory :invoice }
  
  it { should be_valid }
  it { should belong_to :student }

  context "Calculations" do
    it "should return correct calculations for created enrollments" do
      student = Factory :student
      enrollment = Factory :enrollment, :student => student
      payment_period = Factory :payment_period, :enrollment => enrollment
      
      invoice = Invoice.new_on_date(Date.new(2011, 9, 20)).first
      
      invoice.monthly_reference.should == "8091112-#{student.reference_number}"
      invoice.payment_date.should == Date.new(2011, 9, 20) 
      invoice.price.should == BigDecimal('111.11')
      invoice.payers_name.should == student.full_name
      invoice.payers_address.should ==  student.full_address
      invoice.recievers_name.should == Invoice::RECIEVERS_NAME
      invoice.recievers_address.should == Invoice::RECIEVERS_ADDRESS
    end
  end
end
