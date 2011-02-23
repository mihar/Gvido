require 'spec_helper'

describe Schedule do
  subject { Factory :schedule }
  
  it { should be_valid }
end
