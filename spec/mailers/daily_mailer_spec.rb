require "rails_helper"

RSpec.describe DailyMailer, type: :mailer do
  describe "digest" do
    let(:user) { create(:user) }
    let!(:questions_yesterday) { create_list(:question, 2, created_at: Time.zone.now.yesterday)}
    let(:mail) { DailyMailer.digest(user, questions_yesterday) }

    context 'renders' do
      it "the headers" do
        expect(mail.subject).to eq("Digest")
        expect(mail.to).to eq(["#{user.email}"])
        expect(mail.from).to eq(["from@example.com"])
      end

      it "the body" do
        expect(mail.body.encoded).to match("Hello")
      end
    end

    context 'mailer body' do
      # let!(:questions)    { create_list(:question, 2, created_at: Time.zone.now.yesterday) }
      let!(:old_question) { create(:question, attributes_for(:old_question)) }

      it 'have valid questions list' do
        questions_yesterday.each do |question|
          expect(mail.body).to have_content question.title
          expect(mail.body).to have_link( question.title, href: question_url(question))
        end
      end

      it 'have invalid questions list' do
        expect(mail.body).to_not have_content old_question.title
        expect(mail.body).to_not have_link( old_question.title, href: question_url(old_question))
      end
    end
  end
end
