require 'spec_helper'

describe Payment do
  subject { Factory :payment}
  
  it { should be_valid }
  it { should belong_to(:enrollment)}
  
end
