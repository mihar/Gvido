class StatusesController < InheritedResources::Base
  load_and_authorize_resource
  
  layout "dashboard"
  
  def create
    create! { statuses_path }
  end
  
  def update
    update! { statuses_path }
  end
  
  def destroy
    destroy! { statuses_path }
  end
end
