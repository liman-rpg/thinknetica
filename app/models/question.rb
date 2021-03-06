class Question < ActiveRecord::Base
  include Votable
  include Subscriptable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user

  scope :yesterday, -> { where(created_at: Time.zone.now.yesterday.all_day) }

  validates :title, :body, :user_id , presence: true
  validates :title, :body, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
