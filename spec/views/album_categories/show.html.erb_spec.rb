require 'spec_helper'

describe "album_categories/show.html.erb" do
  before(:each) do
    @album_category = assign(:album_category, stub_model(AlbumCategory))
  end

  it "renders attributes in <p>" do
    render
  end
end
