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
  
  it "should crate websafe permalink" do
    subject.save
    subject.permalink.eql?("mentor-joza").should be_true
  end
  
  it "should create a valid full name" do
    subject.full_name.eql?("Mentor Joza").should be_true
  end
    

end
