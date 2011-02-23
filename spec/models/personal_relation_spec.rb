require 'spec_helper'

describe PersonalRelation do
  subject { Factory :personal_relation }
  
  it { should be_valid }
  it { should belong_to :person }
  it { should belong_to :related_person }
  
end
