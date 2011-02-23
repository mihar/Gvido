require 'spec_helper'

describe Notice do
  subject { Factory :notice }
  
  it { should be_valid }
end
