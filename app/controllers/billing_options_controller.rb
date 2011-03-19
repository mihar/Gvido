class BillingOptionsController < InheritedResources::Base
  load_and_authorize_resource
  
  layout "dashboard"
  
  def create
    create! { billing_options_path }
  end
  
  def update
    update! { billing_options_path }
  end
  
  def destroy
    destroy! { billing_options_path }
  end
end
