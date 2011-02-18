require 'spec_helper'

describe "links/show.html.erb" do
  before(:each) do
    @link = assign(:link, stub_model(Link))
  end

  it "renders attributes in <p>" do
    render
  end
end
