require "spec_helper"

describe LocationSectionsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/location_sections" }.should route_to(:controller => "location_sections", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/location_sections/new" }.should route_to(:controller => "location_sections", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/location_sections/1" }.should route_to(:controller => "location_sections", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/location_sections/1/edit" }.should route_to(:controller => "location_sections", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/location_sections" }.should route_to(:controller => "location_sections", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/location_sections/1" }.should route_to(:controller => "location_sections", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/location_sections/1" }.should route_to(:controller => "location_sections", :action => "destroy", :id => "1")
    end

  end
end
