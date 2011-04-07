require 'spec_helper'

describe Mentor do
  subject = Factory(:mentor)
      
  it { should be_valid }
  
  it { should have_and_belong_to_many :instruments }
  it { should have_and_belong_to_many :locations }
  it { should have_and_belong_to_many :gigs }
  it { should have_many :enrollments }
  
  it "should crate websafe permalink" do
    subject.save
    subject.permalink.eql?("mentor-joza").should be_true
  end
  
  it "should create a valid full name" do
    subject.full_name.eql?("Mentor Joza").should be_true
  end
    
  it "should create a user" do
    mentor = Factory.build(:mentor)
    mentor.save
    puts mentor.inspect
    puts '...'
    puts mentor.user.inspect  
    puts '...'
    mentor.user.class.to_s should eql('User')
  end
end
