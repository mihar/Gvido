require 'spec_helper'

describe About do
   
  
  subject { Factory :about }
  
  
  it { should be_valid }
  it { should validate_presence_of :text }
  
  it 'should have same dates on creation' do
    
  end
    
  
end
