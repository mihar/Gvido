require 'spec_helper'

describe Gig do
  subject do
    gig = Factory.build :gig
    gig.mentors << Factory(:mentor)
    gig
  end
  
  it { should be_valid }
  it { should have_and_belong_to_many :mentors }
  
end
