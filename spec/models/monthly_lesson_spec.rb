require 'spec_helper'
 
describe MonthlyLesson do
  subject { Factory :monthly_lesson }
  
  it { should be_valid }
  it { should belong_to :mentor }
  it { should belong_to :student }
  # it { should belong_to :enrollment }
  # it { should belong_to :payment_period }
  
  
  
end
