require 'spec_helper'

describe Contact do
  subject { Factory :contact }
  it { should have_and_belong_to_many :instruments }
  
end
