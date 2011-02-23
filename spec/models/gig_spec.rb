require 'spec_helper'

describe Gig do
  subject do
    gig = Factory.build :gig
    gig.mentors << Factory(:mentor)
    gig
  end
  
  it { should be_valid }
  it { should have_and_belong_to_many :mentors }
  
  it "should include an upcoming gig if there is one" do
    tommorows_gig = Factory.create(:gig, :when => Time.now.tomorrow)
    Gig.upcoming.include?(tommorows_gig).should be_true
  end
  
  it "shouldn't include recent gig in upcoming" do
    recent_gig = Factory.create(:gig, :when => Time.now.yesterday)
    Gig.upcoming.include?(recent_gig).should be_false
  end
  
  it "should include a recent gig if there is one" do
    recent_gig = Factory.create(:gig, :when => Time.now.yesterday)
    Gig.recent.include?(recent_gig).should be_true
  end
  
  it "shouldn't include a gig older then 3 months" do
    old_gig = Factory.create(:gig, :when => 4.month.ago )
    Gig.recent.include?(old_gig).should be_false
  end
  
  #With mentors dilema... 
  it "should include gigs with mentors" do
    mentor = Factory.create(:mentor)
    gig = Factory.build(:gig)
    gig.mentors << mentor
    gig.save
    
    Gig.with_mentors.include?(gig).should be_true
  end
  
  it "shouldn't include gigs without mentors" do
    mentor = Factory.create(:mentor)
    gig = Factory.create(:gig)
    puts '/// with_mentors.inspect ///'
    puts Gig.with_mentors.inspect
    puts '/// gig.inspect ///'
    puts gig.inspect
    Gig.with_mentors.include?(gig).should be_false
  end
  
end
