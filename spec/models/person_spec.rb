require 'spec_helper'

describe Person do
  subject { Factory :person }
  
  it { should be_valid }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should belong_to(:mother) }
  it { should belong_to(:father) }
  
  it "should have momma and poppa if added" do
    tata = Factory :person, :first_name => "Tata", :student => false
    mama = Factory :person, :first_name => "Mata", :student => false
    student = Factory :person, :student => true
    
    student.mother= mama
    student.father= tata
    student.save
    
    student.mother.should eql(mama)
    student.father.should eql(tata)
  end
  
  it "shouldnt have parents if not added" do
    student = Factory :person, :student => true
    student.mother.should eql(nil)
    student.father.should eql(nil)
  end
  
  it "should return a proper full name" do
    subject.full_name.should eql('Mikakhil Mekakil')
  end
  
  it "should properly titelize first and last name" do
    student = Factory.build(:person, :first_name => 'mala', :last_name => 'slova')
    student.save
    
    student.first_name.should eql('Mala')
    student.last_name.should eql('Slova')
  end 
  
  it "shouldn't include paretns in students scope" do
    Factory :person, :first_name => "Tata", :student => false
    Factory :person, :first_name => "Mata", :student => false
    Factory :person, :student => true
    
    Person.students.length.should eql(1)
  end
  
  it "shouldn't include students in others scope" do
    Factory :person, :first_name => "Tata", :student => false
    Factory :person, :first_name => "Mata", :student => false
    Factory :person, :student => true
    
    Person.others.length.should eql(2)
  end
  
  it "should properly order students in students scope" do
    Factory :person, :first_name => "B", :last_name => 'A', :student => true
    b = Factory :person, :first_name => "B", :last_name => 'B', :student => true
    a = Factory :person, :first_name => "A", :last_name => 'A', :student => true
    Factory :person, :first_name => "A", :last_name => 'B', :student => true
    
    organized_students_list = Person.students
    organized_students_list.first.should eql(a)
    organized_students_list.last.should eql(b)
  end
end
