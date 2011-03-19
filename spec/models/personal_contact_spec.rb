require 'spec_helper'

describe PersonalContact do
  subject { Factory :personal_contact }
  
  it { should be_valid }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should belong_to(:post_office) }
  it { should belong_to(:student) }

  it "should return a proper full name" do
    subject.full_name.should eql('Grenpa Mekakil')
  end
  
  it "should properly titelize first and last name" do
    personal_contact = Factory :personal_contact, :first_name => 'mala', :last_name => 'slova'
    personal_contact.first_name.should eql('Mala')
    personal_contact.last_name.should eql('Slova')
  end
end
