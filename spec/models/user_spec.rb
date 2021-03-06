require 'spec_helper'

describe User do
  subject { Factory :user }
  
  it { should be_valid }
  
  it { should belong_to(:mentor) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }

  it "should validate presence of password on create" do
    user = Factory.build :user
    user.should validate_presence_of(:password)
  end
  
  it "should not let invalida emails through" do
    subject.email = "habala.babala"
    subject.should have(1).error_on(:email)
  end
end
