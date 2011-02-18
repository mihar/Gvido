require 'spec_helper'

describe "mentors/edit.html.erb" do
  before(:each) do
    @mentor = assign(:mentor, stub_model(Mentor))
  end

  it "renders the edit mentor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => mentors_path(@mentor), :method => "post" do
    end
  end
end
