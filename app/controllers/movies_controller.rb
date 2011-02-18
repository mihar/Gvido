class MoviesController < InheritedResources::Base
  before_filter :set_section
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

  private
  
  def set_section
    @section = :albums
  end
end
