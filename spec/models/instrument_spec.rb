require 'spec_helper'

describe Instrument do
  subject { Factory :instrument }
  
  it { should be_valid }
  it { should have_many :shop_advices }
  it { should have_and_belong_to_many :mentors }
  it { should have_and_belong_to_many :contacts }
  
  it "should create proper image titles" do
    subject.icon.eql?("instruments/habala-babala.png").should be_true
    subject.icon_medium.eql?("instruments/medium/habala-babala.png").should be_true
    subject.icon_small.eql?("instruments/small/habala-babala.png").should be_true
  end
  
  it "should crate websafe permalink" do
    subject.permalink.eql?("habala-babala").should be_true
  end
  
end
