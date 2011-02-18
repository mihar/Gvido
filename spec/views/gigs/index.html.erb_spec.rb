require 'spec_helper'

describe "gigs/index.html.erb" do
  before(:each) do
    assign(:gigs, [
      stub_model(Gig),
      stub_model(Gig)
    ])
  end

  it "renders a list of gigs" do
    render
  end
end
