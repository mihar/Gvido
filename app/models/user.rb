class User < ActiveRecord::Base
  has_one :mentor
  has_many :lessons
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :admin, :email, :password, :password_confirmation, :remember_me
  
  validates_presence_of :first_name, :last_name, :email, :password
  
  def mentor?
    not mentor.nil?
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def to_s
    full_name
  end
end
