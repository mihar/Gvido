require 'spec_helper'

describe "instruments/new.html.erb" do
  before(:each) do
    assign(:instrument, stub_model(Instrument).as_new_record)
  end

  it "renders new instrument form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => instruments_path, :method => "post" do
    end
  end
end
