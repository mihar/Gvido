require 'spec_helper'

describe "links/index.html.erb" do
  before(:each) do
    assign(:links, [
      stub_model(Link),
      stub_model(Link)
    ])
  end

  it "renders a list of links" do
    render
  end
end
