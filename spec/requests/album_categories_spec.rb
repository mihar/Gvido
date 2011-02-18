require 'spec_helper'

describe "AlbumCategories" do
  describe "GET /album_categories" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get album_categories_path
      response.status.should be(200)
    end
  end
end
