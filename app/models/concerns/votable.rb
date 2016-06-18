module Votable
  extend ActiveSupport::Concern

  included do
     has_many :votes, as: :votable, dependent: :destroy

    def vote_up(user)
      self.votes.create(user: user, score: 1)
    end

    def vote_down(user)
      self.votes.create(user: user, score: -1)
    end

    def vote_cancel(user)
      self.votes.find_by(user: user).destroy if self.votes.exists?(user: user)
    end

    def total
      self.votes.sum(:score)
    end
  end
end
