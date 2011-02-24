require 'spec_helper'

describe Person do
  subject { Factory :person }
  
  it { should be_valid }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should have_many(:relations) }
  it { should have_many(:people) }
  
  it "should have related people" do
    tata = Factory :person, :first_name => "Tata", :person_type => Person::DAD
    mama = Factory :person, :first_name => "Mata", :person_type => Person::MOM
    student = Factory :person, :first_name => "Dete", :person_type => Person::STUDENT
    
    student.relations << tata
    student.relations << mama
    
    student.relations.length.should eql(2)
  end
  
  #it "should have mothers" do
  #  mama = Person.create :first_name => "Mata"
  #  subject.relations.create :name => "Mati", :person => mama
  #  
  #  subject.mother.first_name.should eql("Mata")
  #end
  #
  #it "should have fathers" do
  #  tata = Person.create :first_name => "Tata"
  #  subject.relations.create :name => "Oče", :person => tata
  #  
  #  subject.father.first_name.should eql("Tata")
  #end
end
