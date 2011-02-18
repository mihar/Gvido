require 'spec_helper'

describe "pages/show.html.erb" do
  before(:each) do
    @page = assign(:page, stub_model(Page))
  end

  it "renders attributes in <p>" do
    render
  end
end
