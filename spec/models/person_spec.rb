require 'spec_helper'

describe Person do
  subject { Factory :person }
  
  it { should be_valid }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should belong_to(:mother) }
  it { should belong_to(:father) }
  
  it "should have momma and poppa if added" do
    tata = Factory :parent
    mama = Factory :parent, :first_name => "Mata"
    student = Factory :student
    
    student.mother= mama
    student.father= tata
    student.save
    
    student.mother.should eql(mama)
    student.father.should eql(tata)
  end
  
  it "shouldnt have parents if not added" do
    student = Factory :student
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
    Factory :parent
    Factory :parent, :first_name => "Mata"
    Factory :student
    
    Person.students.length.should eql(1)
  end
  
  it "shouldn't include students in others scope" do
    Factory :parent
    Factory :parent, :first_name => "Mata"
    Factory :student
    
    Person.others.length.should eql(2)
  end
  
  it "should properly order parents in others scope" do
    last = Factory :parent
    Factory :parent
    Factory :parent
    first = Factory :parent
    
    Person.others.first.should eql(first)
    Person.others.last.should eql(last)
  end
  
  it "should properly order students in students scope" do
    Factory :student, :first_name => "B", :last_name => 'A'
    b = Factory :student, :first_name => "B", :last_name => 'B'
    a = Factory :student, :first_name => "A", :last_name => 'A'
    Factory :student, :first_name => "A", :last_name => 'B'
    
    organized_students_list = Person.students
    organized_students_list.first.should eql(a)
    organized_students_list.last.should eql(b)
  end
end
