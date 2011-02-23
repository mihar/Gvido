class LocationSectionsController < InheritedResources::Base
  respond_to :html
  
  def index
    @locations = Location.all
    super
  end
  
  def create
    create! { location_sections_path}
  end
  
  def update
    update! { location_sections_path}
  end
  
end
