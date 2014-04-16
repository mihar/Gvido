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
      cannot :read, [
        Agreement, 
        BillingOption, 
        Contact, 
        Enrollment, 
        Expense, 
        Invoice, 
        LinkCategory,
        MonthlyLesson,
        Payment,
        PaymentPeriod,
        PaymentPlan,
        Person, 
        PersonalContact,
        PostOffice,
        Student,
        User
      ]
      cannot :show, LocationSection
      cannot :manage, PaymentPeriod
      cannot :manage, MonthlyLesson
    end
  end
end
