class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.mentor?
      can :manage, MonthlyLesson
    else
      can :read, :all
      can [:create, :new_report], Contact
      cannot :read, Person
      cannot :show, LocationSection
      cannot :manage, PaymentPeriod
      cannot :manage, MonthlyLesson
    end
  end
end
