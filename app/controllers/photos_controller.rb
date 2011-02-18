class PhotosController < InheritedResources::Base
  before_filter :set_section
  
  def create
    create! { album_path(parent_object) }
  end
  
  def update
    update! { album_path(parent_object) }
  end
  
  def destroy
    destroy! { album_path(parent_object) }
  end
  
  private
  
  def set_section
    @section = :albums
  end
end
