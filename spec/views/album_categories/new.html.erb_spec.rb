require 'spec_helper'

describe "album_categories/new.html.erb" do
  before(:each) do
    assign(:album_category, stub_model(AlbumCategory).as_new_record)
  end

  it "renders new album_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => album_categories_path, :method => "post" do
    end
  end
end
