require "spec_helper"

describe AboutsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/abouts" }.should route_to(:controller => "abouts", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/abouts/new" }.should route_to(:controller => "abouts", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/abouts/1" }.should route_to(:controller => "abouts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/abouts/1/edit" }.should route_to(:controller => "abouts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/abouts" }.should route_to(:controller => "abouts", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/abouts/1" }.should route_to(:controller => "abouts", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/abouts/1" }.should route_to(:controller => "abouts", :action => "destroy", :id => "1")
    end

  end
end
