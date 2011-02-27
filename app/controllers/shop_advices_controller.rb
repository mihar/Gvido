class ShopAdvicesController < InheritedResources::Base
  load_and_authorize_resource
  belongs_to :instrument, :finder => :find_by_permalink!
  respond_to :html
  
  def create
    create! { instrument_shop_advices_path( parent ) }
  end
  
  def update
    update! { instrument_shop_advices_path( parent ) }
  end
  
  def destroy
    destroy! { instrument_shop_advices_path( parent ) }
  end
  
  private
  
  def set_section
    @section = :instruments
  end
end
