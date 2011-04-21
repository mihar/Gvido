require 'spec_helper'
 
describe Lesson do
  subject { Factory :lesson }
  
  it { should be_valid }
  it { should belong_to :mentor }
  it { should belong_to :student }
  it { should belong_to :payment }
  
end
