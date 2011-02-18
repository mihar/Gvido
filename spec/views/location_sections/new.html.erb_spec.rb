require 'spec_helper'

describe "location_sections/new.html.erb" do
  before(:each) do
    assign(:location_section, stub_model(LocationSection).as_new_record)
  end

  it "renders new location_section form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => location_sections_path, :method => "post" do
    end
  end
end
