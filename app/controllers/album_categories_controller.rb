class AlbumCategoriesController < InheritedResources::Base
  respond_to :html
   
  def create
    create! { albums_path }
  end
  
  def update
    update! { albums_path }
  end
  
  def destroy
    destroy! { albums_path }
  end
  
  def before_destroy
    current_object.albums.each do |a|
      a.album_category_id = nil
      a.save
    end
  end
end
