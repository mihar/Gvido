require 'spec_helper'

describe Mentor do
  subject do
    mentor = Factory.build(:mentor)
    mentor.instruments << Factory(:instrument)
    mentor.locations << Factory(:location)
    mentor.gigs << Factory(:gig)
    mentor
  end
    
  it { should be_valid }
  it { should have_and_belong_to_many :instruments }
  it { should have_and_belong_to_many :locations }
  it { should have_and_belong_to_many :gigs }

end
