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
    subject.full_name.should eql('Mikakhil Mekakil')
  end
  
  it "should properly titelize first and last name" do
    student = Factory :person, :first_name => 'mala', :last_name => 'slova'
    
    student.first_name.should eql('Mala')
    student.last_name.should eql('Slova')
  end
  
  it "should properly order students in students scope" do
    b = Factory :student, :first_name => "B", :last_name => 'B'
    Factory :student, :first_name => "B", :last_name => 'A'
    Factory :student, :first_name => "A", :last_name => 'B'
    a = Factory :student, :first_name => "A", :last_name => 'A'
    
    organized_students_list = Student.all
    organized_students_list.first.should eql(a)
    organized_students_list.last.should eql(b)
  end
  
end
