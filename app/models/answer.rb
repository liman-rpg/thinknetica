class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 5 }
end
