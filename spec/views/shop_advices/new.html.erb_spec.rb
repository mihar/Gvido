require 'spec_helper'

describe "shop_advices/new.html.erb" do
  before(:each) do
    assign(:shop_advice, stub_model(ShopAdvice).as_new_record)
  end

  it "renders new shop_advice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => shop_advices_path, :method => "post" do
    end
  end
end
