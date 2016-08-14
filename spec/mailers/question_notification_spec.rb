require "rails_helper"

RSpec.describe QuestionNotification, type: :mailer do
  describe "send_question_notice" do
    let(:user)      { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:answer)    { create(:answer, question: question)}
    let(:mail)      { QuestionNotification.send_question_notice(question, user) }

    it "renders the headers" do
      expect(mail.subject).to eq('New answer(s) to your subscription!')
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello")
    end
  end
end
