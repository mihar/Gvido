require 'spec_helper'

describe Instrument do
  subject do
    instrument = Factory.build :instrument
    instrument.mentors << Factory(:mentor)
    instrument.contacts << Factory(:contact)
    instrument
  end
  
  it { should be_valid }
  it { should have_many :shop_advices }
  it { should have_and_belong_to_many :mentors }
  it { should have_and_belong_to_many :contacts }
  
end
