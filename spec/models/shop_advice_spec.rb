require 'spec_helper'

describe ShopAdvice do
  subject { Factory :shop_advice }
  
  it { should be_valid }
  it { should belong_to :instrument }
end
