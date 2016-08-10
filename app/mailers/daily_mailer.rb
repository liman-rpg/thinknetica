class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.yesterday.to_a
    mail to: user.email
  end
end
