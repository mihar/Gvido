class AboutsController < InheritedResources::Base
  load_and_authorize_resource
  skip_load_resource :only => :all
  before_filter :set_section
  layout :pick_layout
  
  def create
    create! { all_abouts_path }
  end
  
  def update
    update! { all_abouts_path }
  end
  
  private
  
  def pick_layout
    [:index].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def set_section
    @section = :abouts
  end
end
