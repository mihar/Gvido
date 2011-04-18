require 'spec_helper'

describe Mentor do
  subject { Factory :mentor }

  it { should be_valid }
  
  it { should have_one(:user) }
  it { should have_and_belong_to_many :instruments }
  it { should have_and_belong_to_many :locations }
  it { should have_and_belong_to_many :gigs }
  it { should have_many :enrollments }
  it { should validate_numericality_of(:price_per_private_lesson) }
  it { should validate_numericality_of(:price_per_public_lesson) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:surname) }
  it { should validate_presence_of(:price_per_private_lesson) }
  it { should validate_presence_of(:price_per_public_lesson) }
  
  it "should create websafe permalink" do
    subject.save
    subject.permalink.eql?("mentorij-mentis").should be_true
  end
  
  it "should create a valid full name" do
    subject.full_name.eql?("Mentorij Mentis").should be_true
  end
  
  it "should validate user" do
    mentor = Factory.build :mentor, :user => nil
    mentor.should have(1).error_on(:user)
  end
  
  context "user" do
    it "should inherit name, surname and email from mentor" do
      user = Factory.build :user, :first_name => nil, :last_name => nil, :email => nil
      mentor = Factory.build :mentor, :name => "Milan", :surname => "Pezdir", :email => "milan.pezdir@gov.no", :user => user
      
      mentor.save
      user.save
      
      mentor.user.first_name.should == "Milan"
      mentor.user.last_name.should == "Pezdir"
      mentor.user.email.should == "milan.pezdir@gov.no"
    end
  end
end
