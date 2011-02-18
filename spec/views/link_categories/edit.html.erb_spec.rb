require 'spec_helper'

describe "link_categories/edit.html.erb" do
  before(:each) do
    @link_category = assign(:link_category, stub_model(LinkCategory))
  end

  it "renders the edit link_category form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => link_categories_path(@link_category), :method => "post" do
    end
  end
end
