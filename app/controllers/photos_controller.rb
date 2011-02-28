class PhotosController < InheritedResources::Base
  load_and_authorize_resource
  skip_load_resource :only => :all
  belongs_to :album
  before_filter :set_section
  layout :pick_layout
  
  def create
    create! { all_album_photos_path(parent) } 
  end
  
  def update
    update! { all_album_photos_path(parent) }
  end
  
  def destroy
    destroy! { all_album_photos_path(parent) }
  end
  
  private
  
  def pick_layout
    [:index, :show].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def set_section
    @section = :albums
  end
end
