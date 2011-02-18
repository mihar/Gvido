require 'spec_helper'

describe "location_sections/edit.html.erb" do
  before(:each) do
    @location_section = assign(:location_section, stub_model(LocationSection))
  end

  it "renders the edit location_section form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => location_sections_path(@location_section), :method => "post" do
    end
  end
end
