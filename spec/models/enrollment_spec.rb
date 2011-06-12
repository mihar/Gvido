require 'spec_helper'
require 'pp'

describe Enrollment do
  subject { Factory :enrollment }
  
  it { should be_valid }
  
  it { should validate_presence_of :instrument_id }
  it { should validate_presence_of :mentor_id }
  it { should belong_to :instrument }
  it { should belong_to :mentor }
  it { should belong_to :student }
  it { should have_many :payment_periods }
  it { should validate_numericality_of :nr_of_lessons }
  it { should validate_numericality_of :total_price }
  it { should validate_numericality_of :price_per_lesson }
  it { should validate_numericality_of :prepayment }
  it { should validate_numericality_of :discount }
  
  context "on length change with no invoices settled" do
    context "when enrollment is shortened" do
      it "should destroy out of range payment periods and monthly lessons" do
        enrollment = subject
        payment_period = Factory :payment_period, :enrollment => enrollment
        enrollment.cancel_date = Date.new(2011, 12, 1)
        enrollment.save
        payment_period.end_date = Date.new(2011, 12, 1)
        payment_period.save
        
        enrollment.payment_periods(true).order('end_date ASC') == payment_period
      end
      
      # it "should destroy unsettled invoices that are out of range" do
      #   enrollment = subject
      #   payment_period = Factory :payment_period, :enrollment => enrollment
      #   enrollment.cancel_date = Date.new(2011, 12, 1)
      #   enrollment.save
      #   payment_period.end_date = Date.new(2011, 12, 1)
      #   payment_period.save
      #   
      #   created_invoices = enrollment.student.invoices(true).order('payment_date ASC')
      #   created_invoices.last.payment_date.should == Date.new(2011, 11, 20)
      #   created_invoices.length.should == 3
      #   
      #   pp created_invoices
      #   
      #   #BigDecimal('1000') / 3 = 333.33
      #   created_invoices[0].price.should == BigDecimal('333.33')
      # end
      
      it "should destroy out of range payment_periods" do
        enrollment = subject
        payment_period1 = Factory :payment_period, :enrollment => enrollment, :end_date => Date.new(2011, 10, 1)
        payment_period2 = Factory :payment_period, :enrollment => enrollment, :start_date => Date.new(2011, 10, 1), :end_date => Date.new(2011, 12, 1)
        payment_period3 = Factory :payment_period, :enrollment => enrollment, :start_date => Date.new(2011, 12, 1), :end_date => Date.new(2012, 6, 1)
        enrollment.cancel_date = Date.new(2011, 12, 1)
        enrollment.save
        enrollment.payment_periods(true).order('end_date ASC').last.end_date.should == Date.new(2011, 12, 1)
      end
    end
    
  end
  
  
end