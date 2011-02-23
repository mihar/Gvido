require 'spec_helper'

describe Movie do
  subject { Factory :movie }
  
  it { should be_valid }
  
  it "should get a valid youtube id from a youtube link" do
    subject.youtube.eql?("KmukuBm7Rjs").should be_true
  end
  
  it "should create a valid youtube thumbnail" do
    subject.thumbnail.eql?('http://img.youtube.com/vi/KmukuBm7Rjs/default.jpg').should be_true
  end
end
