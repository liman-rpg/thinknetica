class QuestionNotification < ApplicationMailer
  def send_question_notice(question, user)
    @question = question
    mail(to: user.email, subject: 'New answer(s) to your subscription!')
  end
end
