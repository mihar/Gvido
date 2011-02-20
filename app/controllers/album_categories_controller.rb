class AlbumCategoriesController < InheritedResources::Base
  respond_to :html
   
  def create
    create! { albums_path }
  end
  
  def update
    update! { albums_path }
  end
  
  def destroy
    resource.albums.each do |a|
      a.album_category_id = nil
      a.save
    end
    destroy! { albums_path }
  end
end
