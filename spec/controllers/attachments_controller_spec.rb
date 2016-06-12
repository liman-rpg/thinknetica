require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:attachment_for_question) { question.attachments.first }
    let(:attachment_for_answer) { answer.attachments.first }
    let(:destroy_attachment_for_question) { delete :destroy, id: attachment_for_question, format: :js }
    let(:destroy_attachment_for_answer) { delete :destroy, id: attachment_for_answer, format: :js }
    sign_in_user

    context 'by the author of question' do
      let(:question) { create(:question, :with_attachment, user: @user) }

      it 'delete attachment file from database' do
        attachment_for_question
        expect { destroy_attachment_for_question }.to change(question.attachments, :count).by(-1)
      end

      it 'render destroy.js view' do
        destroy_attachment_for_question
        expect(response).to render_template :destroy
      end
    end

    context 'by not the author of question' do
      let(:question) { create(:question, :with_attachment) }

      it 'doesnt deletes attachment from database' do
        attachment_for_question
        expect { destroy_attachment_for_question }.to_not change(Attachment, :count)
      end
    end

    context 'by the author of answer' do
      let(:answer) { create(:answer, :with_attachment, user: @user) }

      it 'delete attachment file from database' do
        attachment_for_answer
        expect { destroy_attachment_for_answer }.to change(answer.attachments, :count).by(-1)
      end

      it 'render destroy.js view' do
        destroy_attachment_for_answer
        expect(response).to render_template :destroy
      end
    end

    context 'by not the author of answer' do
      let(:answer) { create(:answer, :with_attachment) }

      it 'doesnt deletes attachment from database' do
        attachment_for_answer
        expect { destroy_attachment_for_answer }.to_not change(Attachment, :count)
      end
    end
  end
end
