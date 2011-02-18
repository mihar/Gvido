require 'spec_helper'

describe "notices/show.html.erb" do
  before(:each) do
    @notice = assign(:notice, stub_model(Notice))
  end

  it "renders attributes in <p>" do
    render
  end
end
