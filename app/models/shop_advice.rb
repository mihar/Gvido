class ShopAdvice < ActiveRecord::Base
  belongs_to :instrument
  has_attached_file :photo, 
                    :styles => { :mini => "50x50#", :square => "75x75#", :small => "150x150#", :medium => "180x180#", :normal => "550x550>" },
                    :url  => "/assets/shop_advices/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/shop_advices/:id/:style/:basename.:extension"
  
  def description_html
    RedCloth.new(description).to_html unless description.nil?
  end
end
