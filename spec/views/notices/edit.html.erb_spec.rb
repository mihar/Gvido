require 'spec_helper'

describe "notices/edit.html.erb" do
  before(:each) do
    @notice = assign(:notice, stub_model(Notice))
  end

  it "renders the edit notice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => notices_path(@notice), :method => "post" do
    end
  end
end
