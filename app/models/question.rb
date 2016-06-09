class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable
  belongs_to :user

  validates :title, :body, :user_id , presence: true
  validates :title, :body, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments
end
