require 'spec_helper'

describe Question do
  subject { Factory :question }
  
  it { should be_valid }
end
