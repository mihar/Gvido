require 'spec_helper'

describe "instruments/index.html.erb" do
  before(:each) do
    assign(:instruments, [
      stub_model(Instrument),
      stub_model(Instrument)
    ])
  end

  it "renders a list of instruments" do
    render
  end
end
