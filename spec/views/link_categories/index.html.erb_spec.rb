require 'spec_helper'

describe "link_categories/index.html.erb" do
  before(:each) do
    assign(:link_categories, [
      stub_model(LinkCategory),
      stub_model(LinkCategory)
    ])
  end

  it "renders a list of link_categories" do
    render
  end
end
