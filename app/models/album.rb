class Album < ActiveRecord::Base
  scope :not_categorized, where('album_category_id IS NULL')
  scope :first_photos, where("album_id = #{self.id}").order("RAND()").limit(3)
  
  default_scope order('position')
  
  belongs_to :album_category
  has_many :photos, :dependent => :destroy
  validates_presence_of :title
  
  #def first_photos
  #  Photo.all :conditions => "album_id = #{self.id}", :order => "RAND()", :limit => 3
  #end
end
