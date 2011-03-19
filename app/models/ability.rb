class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      can :read, :all
      can [:create, :new_report], Contact
      cannot :read, Person
      cannot :manage, Payment
    end
  end
end
