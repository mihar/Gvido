class PhotosController < InheritedResources::Base
  load_and_authorize_resource
  belongs_to :album
  before_filter :set_section
  
  def create
    create! { album_path(parent) }
  end
  
  def update
    update! { album_path(parent) }
  end
  
  def destroy
    destroy! { album_path(parent) }
  end
  
  private
  
  def set_section
    @section = :albums
  end
end
