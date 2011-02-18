require 'spec_helper'

describe "instruments/edit.html.erb" do
  before(:each) do
    @instrument = assign(:instrument, stub_model(Instrument))
  end

  it "renders the edit instrument form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => instruments_path(@instrument), :method => "post" do
    end
  end
end
