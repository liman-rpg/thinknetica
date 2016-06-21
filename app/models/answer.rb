class Answer < ActiveRecord::Base
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :attachments , as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def set_as_best!
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
