class Person < ActiveRecord::Base
  belongs_to  :post_office
  before_save :proper_titleization
  validates_presence_of :first_name, :last_name
  
  scope :birthday_today, where("DAYOFMONTH(date_of_birth) = ? AND MONTH(date_of_birth) = ?", Date.today.day, Date.today.month)
  
  def full_name
    if first_name and last_name
      "#{first_name} #{last_name}"
    end
  end
  
  def age
    return unless date_of_birth?
    
    age = Date.today.year - date_of_birth.year
    if Date.today.month < date_of_birth.month ||
        (Date.today.month == date_of_birth.month && date_of_birth.day >= Date.today.day)
      age = age - 1
    end
    age
  end
  
  def to_s
    full_name
  end
  
  protected

  def proper_titleization
    self.first_name = first_name.titleize
    self.last_name = last_name.titleize
  end
end
