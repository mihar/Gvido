require 'spec_helper'

describe LocationSection do
  subject { Factory :location_section}
  
  it { should be_valid }
  it { should have_many :locations}
end
