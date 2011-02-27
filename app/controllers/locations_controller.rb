class LocationsController < InheritedResources::Base
  load_and_authorize_resource
  belongs_to :location_section, :optional => true
  layout :pick_layout
  
  def index
    @locations_grouped = collection.group_by { |l| l.location_section }
    super
  end
  
  def edit
    @mentors = Mentor.all.reject { |m| resource.mentors.include?(m) }
    super
  end
  
  def add_mentor
    resource.mentors << Mentor.find(params[:mentor][:id])
    flash[:notice] = "Mentor dodan lokaciji"
    redirect_to edit_location_path(params[:id])    
  end
  
  def destroy_mentor
    resource.mentors.delete(Mentor.find_by_permalink(params[:mentor_id]))
    flash[:notice] = "Mentor odstranjen iz lokacije"
    redirect_to edit_location_path(params[:id])    
  end
  
  def create
    create! { all_locations_path }
  end
  
  def update
    update! { all_locations_path }
  end
  
  def destroy
    destroy! { all_locations_path }
  end
  
  private
  
  def pick_layout
    [:index, :show].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def collection
    @locations ||= if params[:location_section_id]
      LocationSection.find(params[:location_section_id]).locations
    else
      end_of_association_chain.all
    end
    
    letter = "A"
    @locations = @locations.each { |l| l.letter = letter; letter = letter.next; l }
  end
    
  def set_section
    @section = :abouts
  end
end
