require 'spec_helper'

describe "gigs/show.html.erb" do
  before(:each) do
    @gig = assign(:gig, stub_model(Gig))
  end

  it "renders attributes in <p>" do
    render
  end
end
