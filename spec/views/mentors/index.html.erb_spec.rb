require 'spec_helper'

describe "mentors/index.html.erb" do
  before(:each) do
    assign(:mentors, [
      stub_model(Mentor),
      stub_model(Mentor)
    ])
  end

  it "renders a list of mentors" do
    render
  end
end
