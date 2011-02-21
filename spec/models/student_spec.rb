require 'spec_helper'

describe Student do
  subject { Factory :student }
  
  it { should be_valid }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should have_many(:contacts) }
  it { should have_one(:default_contact) }
  
  it "should have a full name" do
    student = Factory :student, :first_name => "Gvido", :last_name => "Stres"
    student.full_name.should eql("Gvido Stres")
  end
  
end