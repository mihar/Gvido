require 'spec_helper'

describe "location_sections/show.html.erb" do
  before(:each) do
    @location_section = assign(:location_section, stub_model(LocationSection))
  end

  it "renders attributes in <p>" do
    render
  end
end
