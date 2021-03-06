class LocationSectionsController < InheritedResources::Base
  layout :pick_layout
  load_and_authorize_resource
  skip_load_resource :only => :all
  
  def index
    @locations = Location.all
    @json = @locations.to_gmaps4rails do |location, marker|
      marker.infowindow render_to_string(:partial => 'locations/info', :locals => {:location => location})
    end

    super
  end
  
  def create
    create! { all_location_sections_path }
  end
  
  def update
    update! { all_location_sections_path }
  end
  
  def destroy
    destroy! { all_location_sections_path }
  end
  
  private
  
  def pick_layout
    [:index].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
end
