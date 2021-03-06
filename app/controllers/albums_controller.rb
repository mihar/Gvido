class AlbumsController < InheritedResources::Base
  load_and_authorize_resource
  skip_load_resource :only => :all
  before_filter :set_section
  layout :pick_layout
   
  def index
    @albums_by_category = AlbumCategory.includes('albums').order("position ASC").order('created_at DESC')
    @albums_no_category = Album.not_categorized
    @movies = Movie.all
    index!
  end
  
  def create
    create! { all_albums_path }
  end
  
  def update
    update! { all_albums_path }
  end
  
  def destroy
    destroy! { all_albums_path }
  end
  
  private
    
  def pick_layout
    [:index, :show].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def set_section
    @section = :albums
  end
end
