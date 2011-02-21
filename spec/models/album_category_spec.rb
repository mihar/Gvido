require 'spec_helper'

describe AlbumCategory do
  subject { Factory :album_category } 
  it { should be_valid }
end
