class Reference < ActiveRecord::Base
  validates_presence_of :title
  
  def body_html
    RedCloth.new(self.body).to_html unless self.body.blank?
  end
end
