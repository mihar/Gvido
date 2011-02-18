require 'spec_helper'

describe "location_sections/index.html.erb" do
  before(:each) do
    assign(:location_sections, [
      stub_model(LocationSection),
      stub_model(LocationSection)
    ])
  end

  it "renders a list of location_sections" do
    render
  end
end
