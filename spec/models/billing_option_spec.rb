require 'spec_helper'

describe BillingOption do
  subject { Factory :billing_option }

  it { should be_valid }
  
end
