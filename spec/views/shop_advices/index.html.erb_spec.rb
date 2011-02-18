require 'spec_helper'

describe "shop_advices/index.html.erb" do
  before(:each) do
    assign(:shop_advices, [
      stub_model(ShopAdvice),
      stub_model(ShopAdvice)
    ])
  end

  it "renders a list of shop_advices" do
    render
  end
end
