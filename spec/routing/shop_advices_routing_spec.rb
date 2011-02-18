require "spec_helper"

describe ShopAdvicesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/shop_advices" }.should route_to(:controller => "shop_advices", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/shop_advices/new" }.should route_to(:controller => "shop_advices", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/shop_advices/1" }.should route_to(:controller => "shop_advices", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/shop_advices/1/edit" }.should route_to(:controller => "shop_advices", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/shop_advices" }.should route_to(:controller => "shop_advices", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/shop_advices/1" }.should route_to(:controller => "shop_advices", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/shop_advices/1" }.should route_to(:controller => "shop_advices", :action => "destroy", :id => "1")
    end

  end
end
