require 'spec_helper'

describe Contact do
  subject do
    contact = Factory.build(:contact)
    contact.instruments << Factory(:instrument)
    contact.locations << Factory(:location)
    contact
  end

  it { should be_valid }
  it { should have_and_belong_to_many :instruments }
  it { should have_and_belong_to_many :locations }
end
