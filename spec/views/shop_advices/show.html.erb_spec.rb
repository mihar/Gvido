require 'spec_helper'

describe "shop_advices/show.html.erb" do
  before(:each) do
    @shop_advice = assign(:shop_advice, stub_model(ShopAdvice))
  end

  it "renders attributes in <p>" do
    render
  end
end
