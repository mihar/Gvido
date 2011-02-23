require 'spec_helper'

describe Instrument do
  subject { Factory :instrument }
  
  it { should be_valid }
  it { should have_many :shop_advices }
  it { should have_and_belong_to_many :mentors }
  it { should have_and_belong_to_many :contacts }
  
end
