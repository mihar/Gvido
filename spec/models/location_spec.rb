require 'spec_helper'

describe Location do
  subject do
    loc = Factory.build(:location)
    loc.mentors << Factory(:mentor)
    loc
  end
  
  it { should be_valid }
  it { should belong_to :location_section}
  it { should have_and_belong_to_many :mentors }
  
  it "http should be added to uri if not present" do
    l = Factory(:location, :uri => 'gugl.si')
    l.uri.should eql('http://gugl.si')
  end
  
  it "uri should stay the same if http is present" do
    l = Factory(:location, :uri => 'http://gugl.si')
    l.uri.eql?('http://gugl.si').should be_true
  end
  
end
