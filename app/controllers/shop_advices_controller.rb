class ShopAdvicesController < InheritedResources::Base
  load_and_authorize_resource
  skip_load_resource :only => :all
  belongs_to :instrument, :finder => :find_by_permalink!
  respond_to :html
  layout :pick_layout
  
  def create
    create! { all_instrument_shop_advices_path( parent ) }
  end
  
  def update
    update! { all_instrument_shop_advices_path( parent ) }
  end
  
  def destroy
    destroy! { all_instrument_shop_advices_path( parent ) }
  end
  
  private
  
  def pick_layout
    [:index].include?(action_name.to_sym) ? "application" : "dashboard"
  end
  
  def set_section
    @section = :instruments
  end
end
