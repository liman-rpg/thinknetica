class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      quest_abilities
    end
  end

  def quest_abilities
      can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    quest_abilities
    #Answer + Question + Comment
    can :create, [ Question, Answer, Comment ]
    can :update, [ Question, Answer ], user: user
    can :destroy, [ Question, Answer ], user: user

    #Question
    can :read, Question

    can :vote_up, Question
    can :vote_down, Question
    can :vote_cancel, Question

    cannot :vote_up, Question, user: user
    cannot :vote_down, Question, user: user
    cannot :vote_cancel, Question, user: user

    #Answer
    can :set_best_answer, Answer, question: { user: user }

    can :vote_up, Answer
    can :vote_down, Answer
    can :vote_cancel, Answer

    cannot :vote_up, Answer, user: user
    cannot :vote_down, Answer, user: user
    cannot :vote_cancel, Answer, user: user
  end
end

    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
