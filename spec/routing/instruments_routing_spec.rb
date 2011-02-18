require "spec_helper"

describe InstrumentsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/instruments" }.should route_to(:controller => "instruments", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/instruments/new" }.should route_to(:controller => "instruments", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/instruments/1" }.should route_to(:controller => "instruments", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/instruments/1/edit" }.should route_to(:controller => "instruments", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/instruments" }.should route_to(:controller => "instruments", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/instruments/1" }.should route_to(:controller => "instruments", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/instruments/1" }.should route_to(:controller => "instruments", :action => "destroy", :id => "1")
    end

  end
end
