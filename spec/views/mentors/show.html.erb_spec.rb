require 'spec_helper'

describe "mentors/show.html.erb" do
  before(:each) do
    @mentor = assign(:mentor, stub_model(Mentor))
  end

  it "renders attributes in <p>" do
    render
  end
end
