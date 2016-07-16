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

    alias_action :update, :destroy, :to => :modify
    alias_action :vote_up, :vote_down, :vote_cancel, :to => :vote
    #Answer + Question + Comment
    can :create, [ Question, Answer, Comment ]
    can :modify, [ Question, Answer ], user: user
    can :vote,   [ Question, Answer ] { |votable| votable.user_id != user.id }

    #Question
    can :read, Question

    #Answer
    can :set_best_answer, Answer, question: { user: user }

    #Attachment
    can :destroy, Attachment, attachable: { user: user }
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
