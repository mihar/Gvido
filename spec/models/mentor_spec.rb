require 'spec_helper'

describe Mentor do
  subject  do
    mentor = Factory.build :mentor
    mentor.save
    mentor
  end
      
  it { 
    unless subject.errors.empty?
      puts '-- Napake pri shranjevanju --'
      puts subject.errors.inspect
    end
    should be_valid 
  }
  
  it { should have_and_belong_to_many :instruments }
  it { should have_and_belong_to_many :locations }
  it { should have_and_belong_to_many :gigs }
  it { should have_many :enrollments }
  it { should validate_numericality_of(:price_per_private_lesson) }
  it { should validate_numericality_of(:price_per_public_lesson) }
  
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
