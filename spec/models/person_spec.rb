require 'spec_helper'

describe Person do
  subject { Factory :person }
  
  it { should have_many(:relations) }
  it { should have_many(:people) }
  
end
