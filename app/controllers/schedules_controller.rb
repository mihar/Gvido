class SchedulesController < InheritedResources::Base
  layout :pick_layout
  skip_load_resource :only => :all
  load_and_authorize_resource
  
  def create
    create! { all_schedules_path }
  end
  
  def update
    update! { all_schedules_path }
  end
  
  def destroy
    destroy! { all_schedules_path }
  end
  
  private
  
  def pick_layout
    [:index].include?(action_name.to_sym) ? "application" : "dashboard"
  end
end
