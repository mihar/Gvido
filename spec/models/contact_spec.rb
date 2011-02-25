require 'spec_helper'

describe Contact do
  subject { Factory :contact }
  
  it { should be_valid }
  it { should have_and_belong_to_many :instruments }
  it { should have_and_belong_to_many :locations }
  
  it "should not validate if no instruments are assigned" do
    subject.instruments = []
    
    subject.should_not be_valid
    subject.should have(1).errors_on(:instrument_ids)
  end
  
  it "should not validate if no locations are assigned" do
    subject.locations = []
    
    subject.should_not be_valid
    subject.should have(1).errors_on(:location_ids)
  end
end
