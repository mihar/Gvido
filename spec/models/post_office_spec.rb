require 'spec_helper'

describe PostOffice do
  subject { Factory :post_office }
  
  it { should be_valid }
  it { should validate_presence_of(:id) }
  it { should validate_numericality_of(:id) }
  it { should validate_uniqueness_of(:id) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should have_many(:people) }
end
