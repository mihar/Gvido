require 'spec_helper'

describe "references/index.html.erb" do
  before(:each) do
    assign(:references, [
      stub_model(Reference),
      stub_model(Reference)
    ])
  end

  it "renders a list of references" do
    render
  end
end
