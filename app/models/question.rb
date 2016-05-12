class Question < ActiveRecord::Base
  has_many :answers , dependent: :destroy
  belongs_to :user

  validates :title, :body, length: { minimum: 5 }, presence: true
end
