class GigsController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
  
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
  
  protected
  
  def set_section
    @section = :gigs
  end
  
  def collection
    @gigs ||= end_of_association_chain.recent.with_mentors
  end
end
