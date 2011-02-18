require 'spec_helper'

describe "gigs/new.html.erb" do
  before(:each) do
    assign(:gig, stub_model(Gig).as_new_record)
  end

  it "renders new gig form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => gigs_path, :method => "post" do
    end
  end
end
