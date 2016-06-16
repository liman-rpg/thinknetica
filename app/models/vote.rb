class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :score, :user_id, :votable_type, :votable_id, presence: true
  validates :votable_id, uniqueness: { scope: [:votable_type, :user_id] }
  validates :score , inclusion: { in: -1..1 }
end
