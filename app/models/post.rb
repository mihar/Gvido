class Post < ActiveRecord::Base
  default_scope order("created_at DESC")

  validates_presence_of :title, :text
  
  def text_html
    RedCloth.new(self.text).to_html
  end
end
