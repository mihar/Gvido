require 'spec_helper'

describe Student do
  subject { Factory :student }
  
  it { should be_valid }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:status_id) }
  it { should belong_to(:post_office) }
  it { should belong_to(:status) }
  it { should have_many(:personal_contacts) }
  it { should have_many(:enrollments) }

  it "should return a proper full name" do
    subject.full_name.should eql('Mekakil Mikakhil')
  end
  
  it "should properly titelize first and last name" do
    student = Factory :person, :first_name => 'mala', :last_name => 'slova'
    
    student.first_name.should eql('Mala')
    student.last_name.should eql('Slova')
  end
  
  it "should return full address" do
    subject.full_address.should == "Jenkova 56, 3320 Velenje"
  end
  
end
