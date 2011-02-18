require 'spec_helper'

describe "abouts/edit.html.erb" do
  before(:each) do
    @about = assign(:about, stub_model(About,
      :text => "MyText",
      :contact => "MyText"
    ))
  end

  it "renders the edit about form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => abouts_path(@about), :method => "post" do
      assert_select "textarea#about_text", :name => "about[text]"
      assert_select "textarea#about_contact", :name => "about[contact]"
    end
  end
end
