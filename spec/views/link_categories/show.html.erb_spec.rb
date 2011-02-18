require 'spec_helper'

describe "link_categories/show.html.erb" do
  before(:each) do
    @link_category = assign(:link_category, stub_model(LinkCategory))
  end

  it "renders attributes in <p>" do
    render
  end
end
