class AlbumCategoriesController < InheritedResources::Base
  layout :pick_layout
  load_and_authorize_resource
  skip_load_resource :only => :all
   
  def create
    create! { all_album_categories_path }
  end
  
  def update
    update! { all_album_categories_path }
  end
  
  def destroy
    resource.albums.each do |a|
      a.album_category_id = nil
      a.save
    end
    destroy! { all_album_categories_path }
  end
  
  private
  
  def pick_layout
    [:index].include?(action_name.to_sym) ? "application" : "dashboard"
  end
end
