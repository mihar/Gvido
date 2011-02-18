class LocationSectionsController < InheritedResources::Base
  respond_to :html
  
  def index
    @location_sections = LocationSection.all
    @locations = Location.all
    super
  end
end
