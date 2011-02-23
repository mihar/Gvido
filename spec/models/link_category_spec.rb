require 'spec_helper'

describe LinkCategory do
  subject { Factory :link_category }
  
  it { should be_valid }
  it { should have_many :links }
end
