require 'spec_helper'

describe "ShopAdvices" do
  describe "GET /shop_advices" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get shop_advices_path
      response.status.should be(200)
    end
  end
end
