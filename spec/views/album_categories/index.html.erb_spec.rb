require 'spec_helper'

describe "album_categories/index.html.erb" do
  before(:each) do
    assign(:album_categories, [
      stub_model(AlbumCategory),
      stub_model(AlbumCategory)
    ])
  end

  it "renders a list of album_categories" do
    render
  end
end
