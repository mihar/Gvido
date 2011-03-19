require 'spec_helper'

describe Person do
  subject { Factory :person }
  
  it { should be_valid }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should belong_to(:post_office) }

  it "should return a proper full name" do
    subject.full_name.should eql('Mikakhil Mekakil')
  end
  
  it "should properly titelize first and last name" do
    student = Factory :person, :first_name => 'mala', :last_name => 'slova'
    
    student.first_name.should eql('Mala')
    student.last_name.should eql('Slova')
  end 
  
end
