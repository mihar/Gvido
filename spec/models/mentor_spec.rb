require 'spec_helper'

describe Mentor do
  subject  do
    mentor = Factory.build :mentor
    mentor.save
    mentor
  end
      
  it { should be_valid }
  
  it { should have_and_belong_to_many :instruments }
  it { should have_and_belong_to_many :locations }
  it { should have_and_belong_to_many :gigs }
  it { should have_many :enrollments }

  
  it "should crate websafe permalink" do
    subject.save
    subject.permalink.eql?("mentorij-mentis").should be_true
  end
  
  it "should create a valid full name" do
    subject.full_name.eql?("Mentorij Mentis").should be_true
  end
    
  it "should create a user" do
    subject.user.should be_a_kind_of User
  end
end
