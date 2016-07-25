require 'rails_helper'

describe 'Answer API' do
  let(:user)         { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let(:question)     { create(:question) }

  describe 'GET #show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:answer)     { create(:answer, :with_attachment) }
      let(:attachment)  { answer.attachments.first }
      let!(:comment)    { create(:comment, commentable: answer) }

      before { get "/api/v1//answers/#{ answer.id }", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{ attr }" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{ attr }")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{ attr }" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{ attr }")
          end
        end
      end

      context 'attachment' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        it 'contain id' do
          expect(response.body).to be_json_eql(attachment.id.to_json).at_path("answer/attachments/0/id")
        end

        it 'contain url in file' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1//answers/1", { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    let(:answer) { create(:answer, question: question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      context 'with vailid params' do
        let(:create_valid_answer) { post "/api/v1/questions/#{ question.id }/answers", format: :json, question_id: question.id, access_token: access_token.token, answer: attributes_for(:answer) }
        let(:answer_last) { Answer.last }

        it 'save in database' do
          expect{ create_valid_answer }.to change(Answer, :count).by(1)
        end

        context 'after create' do
          before { create_valid_answer }

          it 'returns 201 status' do
            expect(response).to be_success
          end

          %w(id body created_at updated_at).each do |attr|
            it "contains #{ attr }" do
              expect(response.body).to be_json_eql(answer_last.send(attr.to_sym).to_json).at_path("answer/#{ attr }")
            end
          end

          it 'check attributes' do
            answer_last.reload

            expect(answer_last.body).to eq answer_last[:body]
            expect(answer_last.user_id).to eq user.id
          end
        end
      end

      context 'question with invailid params' do
        let(:create_invalid_answer) { post "/api/v1/questions/#{ question.id }/answers", format: :json, question_id: question.id, access_token: access_token.token, answer: attributes_for(:invalid_answer) }

        it 'not save in database' do
          expect{ create_invalid_answer }.to_not change(Answer, :count)
        end

        context 'after create' do
          before { create_invalid_answer }

          it 'returns 422 status' do
            expect(response.status).to eq 422
          end
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{ question.id }/answers", { format: :json }.merge(options)
    end
  end
end
