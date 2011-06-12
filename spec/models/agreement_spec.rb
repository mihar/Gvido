require 'spec_helper'

describe Agreement do
  subject { Factory :agreement }
  
  it { should be_valid }
  it { should validate_presence_of :text }
end
