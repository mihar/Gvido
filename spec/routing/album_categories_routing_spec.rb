require "spec_helper"

describe AlbumCategoriesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/album_categories" }.should route_to(:controller => "album_categories", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/album_categories/new" }.should route_to(:controller => "album_categories", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/album_categories/1" }.should route_to(:controller => "album_categories", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/album_categories/1/edit" }.should route_to(:controller => "album_categories", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/album_categories" }.should route_to(:controller => "album_categories", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/album_categories/1" }.should route_to(:controller => "album_categories", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/album_categories/1" }.should route_to(:controller => "album_categories", :action => "destroy", :id => "1")
    end

  end
end
