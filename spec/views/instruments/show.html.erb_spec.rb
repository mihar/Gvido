require 'spec_helper'

describe "instruments/show.html.erb" do
  before(:each) do
    @instrument = assign(:instrument, stub_model(Instrument))
  end

  it "renders attributes in <p>" do
    render
  end
end
