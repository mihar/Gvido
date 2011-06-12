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
  
  it "should change created_at and updated_at" do
    monthly_lesson = Factory :monthly_lesson, :date => Date.new(2011, 9, 1), :created_at => DateTime.new(2011, 10, 1), :updated_at => DateTime.new(2011, 10, 1)
    monthly_lesson.created_at.should == DateTime.new(2011, 10, 1)
    monthly_lesson.updated_at.should == DateTime.new(2011, 10, 1)
  end
  
  it "should create same values for created_at and updated_at" do
    monthly_lesson = Factory :monthly_lesson, :date => Date.new(2011, 9, 1)
    monthly_lesson.created_at.should == monthly_lesson.updated_at
  end
  
  context "method inactive_on_date" do
    context "when mentor has not jet entered any monthly lessons" do
      it "should return a correct dates at beginning of month" do
        Factory :payment_period
        current_date = Date.new(2011, 10, 1)
        hash = Mentor.inactive_on_date(current_date)
        
        hash[0][:payment_date].should == Date.new(2011, 9, 20)
        hash[1][:payment_date].should == Date.new(2011, 10, 20)
      end      
    end
    
    context "when mentor updated students hours in in spetember" do
      it "should return october" do
        mentor = Factory :mentor
        enrollment = Factory :enrollment, :mentor => mentor
        Factory :payment_period, :enrollment => enrollment
        mentor.update_attribute :last_hours_entry_at, DateTime.new(2011, 9, 1)
        current_date = Date.new(2011, 10, 1)
        
        hash = Mentor.inactive_on_date(current_date)
        hash[0][:payment_date].should == Date.new(2011, 10, 20)
      end      
    end
  end
  
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
