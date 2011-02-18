require 'spec_helper'

describe "shop_advices/edit.html.erb" do
  before(:each) do
    @shop_advice = assign(:shop_advice, stub_model(ShopAdvice))
  end

  it "renders the edit shop_advice form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => shop_advices_path(@shop_advice), :method => "post" do
    end
  end
end
