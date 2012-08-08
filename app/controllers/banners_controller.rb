class BannersController < InheritedResources::Base
  load_and_authorize_resource
  before_filter :set_section
  layout "dashboard"
   
  def create
    create! { banners_path }    
  end

  def destroy
    destroy! { banners_path }
  end

  private
  
  def set_section
    @section = :banners
  end
end
