require 'spec_helper'

describe Movie do
  subject { Factory :movie }
  
  it { should be_valid }
end
