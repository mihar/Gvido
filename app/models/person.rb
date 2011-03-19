class Person < ActiveRecord::Base
  belongs_to  :post_office
  before_save :proper_titleization
  validates_presence_of :first_name, :last_name
    
  def full_name
    if first_name and last_name
      "#{first_name} #{last_name}"
    end
  end
  
  protected

  def proper_titleization
    self.first_name = first_name.titleize
    self.last_name = last_name.titleize
  end
end
