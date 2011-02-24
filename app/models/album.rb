class Album < ActiveRecord::Base
  scope :not_categorized, where('album_category_id IS NULL')
  default_scope order('position')
  
  belongs_to :album_category
  has_many :photos, :dependent => :destroy do
    def three_random
      order("RAND()").limit(3)
    end
  end
  validates_presence_of :title
  
end
