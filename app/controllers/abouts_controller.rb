class AboutsController < InheritedResources::Base
  before_filter :set_section
  respond_to :html
  
  def create
    create! { abouts_path }
  end
  
  def update
    update! { abouts_path }
  end
  
  private 
  
  def set_section
    @section = :abouts
  end
end
