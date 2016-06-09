class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments , as: :attachable

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments

  def set_as_best!
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
