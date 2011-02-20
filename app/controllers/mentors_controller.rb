class MentorsController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
  
  def edit
    @instruments = Instrument.all.reject { |i| resource.instruments.include?(i) }
    edit!
  end

  def add_instrument
    resource.instruments << Instrument.find(params[:instrument][:id])
    flash[:notice] = "Instrument dodan mentorju"
    redirect_to edit_mentor_path(params[:id])
  end
  
  def destroy_instrument
    resource.instruments.delete(Instrument.find_by_permalink(params[:instrument_id]))
    flash[:notice] = "Instrument odstranjen od mentorja"
    redirect_to edit_mentor_path(params[:id])
  end

  def update_positions
    params[:mentors].each_with_index do |id, position|
      Mentor.update(id, :position => position)
    end
    render :nothing => true
  end
  
  protected
  
  def set_section
    @section = :abouts
  end
  
  def resource
    @mentor ||= end_of_association_chain.find_by_permalink params[:id]
  end
end
