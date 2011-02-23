require 'spec_helper'

describe Reference do
  subject { Factory :reference }
  
  it { should be_valid }
end
