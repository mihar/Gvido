require "spec_helper"

describe GigsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/gigs" }.should route_to(:controller => "gigs", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/gigs/new" }.should route_to(:controller => "gigs", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/gigs/1" }.should route_to(:controller => "gigs", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/gigs/1/edit" }.should route_to(:controller => "gigs", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/gigs" }.should route_to(:controller => "gigs", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/gigs/1" }.should route_to(:controller => "gigs", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/gigs/1" }.should route_to(:controller => "gigs", :action => "destroy", :id => "1")
    end

  end
end
