class MentorsController < InheritedResources::Base
  load_and_authorize_resource
  layout :pick_layout
  
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
  
  def edit_login_account
    @user = Mentor.find_by_permalink(params[:id]).user
    @user.email = @user.email
    @user.password = ''
    @user.password_confirmation = ''
  end
  
  def update_login_account
    @user = Mentor.find_by_permalink(params[:id]).user
    @user.email = params[:email]
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.first_name = @user.mentor.name
    @user.last_name = @user.mentor.surname

    if @user.save
      flash[:notice] = "Mentorjevi prijavni podatki so bili uspešno posodobljeni."
      redirect_to details_mentor_path(@user.mentor)
    else
      flash[:error] = "Prišlo je do napake pri shranjevanju mentorjevih prijavnih podatkov."
      render :action => :edit_login_account
    end
  end
  
  def details
    @enrollments = resource.enrollments
  end
  
  def create
    create! { all_mentors_path }
  end
  
  def update
    update! { all_mentors_path }
  end
  
  def destroy
    destroy! { all_mentors_path }
  end
  
  private
  
  def pick_layout
    if [:index, :show].include?(action_name.to_sym)
      @section = :abouts
      "application"
    else
      @section = :mentors
      "dashboard"
    end
  end
  
  protected
  
  def resource
    @mentor ||= end_of_association_chain.find_by_permalink params[:id]
  end
end
