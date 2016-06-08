class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 5 }

  def set_as_best!
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
