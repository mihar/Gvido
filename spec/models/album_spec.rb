require 'spec_helper'

describe Album do
  subject { Factory :album }
  
  it { should be_valid }
  it { should belong_to(:album_category) }
  it { should have_many(:photos) }
  it { should validate_presence_of(:title) }
  
  it "should have three random photos" do
    
    subject.photos << Factory(:photo, :album => subject)
    subject.photos << Factory(:photo, :album => subject)
    subject.photos << Factory(:photo, :album => subject)
    subject.photos << Factory(:photo, :album => subject)
    subject.photos << Factory(:photo, :album => subject)    
    subject.photos.three_random.length.should == 3
  end
    
end
