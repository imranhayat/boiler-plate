class Ability
  include CanCan::Ability
  def initialize(user)
    if user.admin?
      can :read, :all
      cannot :update, :all
      cannot :destroy, :all
      can :manage, :admin_panel
    else
      cannot :manage,:all
    end
  end
end
