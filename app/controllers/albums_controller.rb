class AlbumsController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
  
  def index
    @albums_by_category = AlbumCategory.includes('albums')
    @albums_no_category = Album.not_categorized
    @movies = Movie.all
    super
  end
  
  private
  
  def set_section
    @section = :albums
  end
end
