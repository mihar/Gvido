require 'spec_helper'

describe Album do
  subject { Factory :album }
  it { should be_valid }
  it { should belong_to(:album_category) }
  it { should have_many(:photos) }
  it { should validate_presence_of(:title) }
end
