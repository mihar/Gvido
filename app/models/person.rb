# Encoding: utf-8

class Person < ActiveRecord::Base
  belongs_to  :post_office
  before_save :proper_titleization, :split_date_of_birth
  validates_presence_of :first_name, :last_name
  
  scope :birthday_today, where("day_of_birth = ?", Date.today.day).where("month_of_birth = ?", Date.today.month)
  
  def full_name
    if first_name and last_name
      "#{last_name} #{first_name}"
    end
  end
  
  def reverse_full_name
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
  
  def full_address
    _post_office = '' #string format: po_number city
    
    if place.present? and post_office.present?  # place and post_office are entered
      _post_office = post_office.id.to_s + ' ' + place
    elsif place.present? and post_office.present? == false  # only place is entered
      p_o = PostOffice.find_by_name(place)
      if p_o
        _post_office = p_o.id.to_s + ' ' + p_o.name
      else
        _post_office = place + 'Naslov ni popoln, poštna številka ni izbrana!'
      end
    elsif post_office.present? and place.present? == false  # only post_office is entered
      _post_office = post_office.id.to_s + ' ' + post_office.name
    else
      _post_office = 'Naslov ni popoln, kraj in poštna številka nista vnesena!'
    end
    
    if address.present?  # addres is entered
      return address + ', ' + _post_office
    else
      return "Niste vnesli naslov, poštno številko in kraj!"
    end
    
    return _post_office
  end
  
  def to_s
    full_name
  end
  
  protected

  def split_date_of_birth
    return unless date_of_birth
    self.day_of_birth = date_of_birth.day
    self.month_of_birth = date_of_birth.month
    self.year_of_birth = date_of_birth.year
  end

  def proper_titleization
    self.first_name = first_name.titleize
    self.last_name = last_name.titleize
  end
end
