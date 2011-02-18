class SchedulesController < InheritedResources::Base
  respond_to :html
  
  def create
    create! { schedules_path }
  end
  
  def update
    update! { schedules_path }
  end
  
  def destroy
    destroy! { schedules_path }
  end
  
end
