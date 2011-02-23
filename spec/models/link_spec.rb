require 'spec_helper'

describe Link do
  subject { Factory :link }
  
  it { should be_valid }
  it { should belong_to :category  }
end
