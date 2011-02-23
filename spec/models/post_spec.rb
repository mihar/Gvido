require 'spec_helper'

describe Post do
  subject { Factory :post }
  
  it { should be_valid }
end
