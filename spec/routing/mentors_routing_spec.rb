require "spec_helper"

describe MentorsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/mentors" }.should route_to(:controller => "mentors", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/mentors/new" }.should route_to(:controller => "mentors", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/mentors/1" }.should route_to(:controller => "mentors", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/mentors/1/edit" }.should route_to(:controller => "mentors", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/mentors" }.should route_to(:controller => "mentors", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/mentors/1" }.should route_to(:controller => "mentors", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/mentors/1" }.should route_to(:controller => "mentors", :action => "destroy", :id => "1")
    end

  end
end
