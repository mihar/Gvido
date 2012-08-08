class LinkCategory < ActiveRecord::Base
  has_many :links, :foreign_key => "category_id"

  def to_s
    title
  end
end
