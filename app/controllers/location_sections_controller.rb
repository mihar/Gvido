class LocationSectionsController < InheritedResources::Base
  respond_to :html
  
  def index
    @locations = Location.all
    super
  end
end
