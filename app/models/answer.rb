class Answer < ActiveRecord::Base
  include Votable

  belongs_to :question
  belongs_to :user
  has_many :attachments , as: :attachable, dependent: :destroy
  has_many :comments , as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true
  validates :body, length: { minimum: 5 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_commit :mail_notice, on: :create

  def set_as_best!
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

  def mail_notice
    @question = self.question
    @question.subscriptions.each do |subscription|
      QuestionNotification.delay.send_question_notice(@question, subscription.user)
    end
  end
end
