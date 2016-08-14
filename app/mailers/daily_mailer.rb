class DailyMailer < ApplicationMailer
  def digest(user, questions_yesterday)
    @questions = questions_yesterday
    mail to: user.email
  end
end
