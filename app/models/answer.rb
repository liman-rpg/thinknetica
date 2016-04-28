class Answer < ActiveRecord::Base
  belongs_to :question

  validates :body, length: { minimum: 5 }, presence: true
end
