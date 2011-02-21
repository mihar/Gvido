require 'spec_helper'

describe About do
  subject { Factory :about }

  it { should be_valid }
  it { should validate_presence_of :text }
  
end
