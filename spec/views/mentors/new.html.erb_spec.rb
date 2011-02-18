require 'spec_helper'

describe "mentors/new.html.erb" do
  before(:each) do
    assign(:mentor, stub_model(Mentor).as_new_record)
  end

  it "renders new mentor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => mentors_path, :method => "post" do
    end
  end
end
