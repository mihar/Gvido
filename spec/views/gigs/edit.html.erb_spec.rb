require 'spec_helper'

describe "gigs/edit.html.erb" do
  before(:each) do
    @gig = assign(:gig, stub_model(Gig))
  end

  it "renders the edit gig form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => gigs_path(@gig), :method => "post" do
    end
  end
end
