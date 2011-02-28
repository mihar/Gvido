class GigsController < InheritedResources::Base
  load_and_authorize_resource
  skip_load_resource :only => :all
  before_filter :set_section
  
  # Different layouts here.
  layout :pick_layout
  
  def index
    @gigs = Gig.recent.with_mentors
  end
  
  def edit 
    @mentors = Mentor.all.reject { |m| resource.mentors.include?(m) }
    edit!
  end
  
  def add_mentor
    resource.mentors << Mentor.find(params[:mentor][:id])
    flash[:notice] = "Mentor dodan koncertu."
    redirect_to edit_gig_path(params[:id])
  end
  
  def destroy_mentor
    resource.mentors.delete(Mentor.find_by_permalink(params[:mentor_id]))
    flash[:notice] = "Mentor odstranjen iz koncerta."
    redirect_to edit_gig_path(params[:id])
  end
  
  def update
    update! { all_gigs_path }
  end
  
  def create
    create! { all_gigs_path }
  end
  
  def destroy
    destroy! { all_gigs_path }
  end
  
  private
  
  def pick_layout
    [:index, :show].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def set_section
    @section = :gigs
  end
end
