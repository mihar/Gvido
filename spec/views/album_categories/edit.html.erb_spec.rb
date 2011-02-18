require 'spec_helper'

describe "album_categories/edit.html.erb" do
  before(:each) do
    @album_category = assign(:album_category, stub_model(AlbumCategory))
  end

  it "renders the edit album_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => album_categories_path(@album_category), :method => "post" do
    end
  end
end
