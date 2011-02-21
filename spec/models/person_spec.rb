require 'spec_helper'

describe Person do
  subject { Factory :person }
  
  it { should be_valid }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should have_many(:relations) }
  it { should have_many(:people) }
  
  it "should have related people" do
    tata = Person.create :first_name => "Tata"
    mama = Person.create :first_name => "Mata"
    subject.relations.create :name => "Mati", :person => mama
    subject.relations.create :name => "Oče", :person => tata
    
    subject.relations.count.should eql(2)
    subject.people.count.should eql(2)
  end
  
  it "should have mothers" do
    mama = Person.create :first_name => "Mata"
    subject.relations.create :name => "Mati", :person => mama
    
    subject.mother.first_name.should eql("Mata")
  end
  
  it "should have fathers" do
    tata = Person.create :first_name => "Tata"
    subject.relations.create :name => "Oče", :person => tata
    
    subject.father.first_name.should eql("Tata")
  end
end
