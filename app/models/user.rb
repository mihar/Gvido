class User < ActiveRecord::Base
  belongs_to :mentor, :dependent => :destroy
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :first_name, :last_name, :admin, :email, :password, :password_confirmation, :remember_me
  
  with_options :if => :should_validate_password? do |v|
    v.validates_presence_of :password
    v.validates_confirmation_of :password
    v.validates_length_of :password, :within => 6..128
  end
  
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  def mentor?
    !!mentor
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def should_validate_password?
    new_record? or not password.blank?
  end
  
  def to_s
    full_name
  end
end