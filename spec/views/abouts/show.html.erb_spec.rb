require 'spec_helper'

describe "abouts/show.html.erb" do
  before(:each) do
    @about = assign(:about, stub_model(About,
      :text => "MyText",
      :contact => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
