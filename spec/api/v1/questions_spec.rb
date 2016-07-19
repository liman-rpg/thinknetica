require 'rails_helper'

describe 'Questions API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET #index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token no vailid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:questions)   { create_list(:question, 3) }
      let(:question)     { questions.first }
      let!(:answer)      { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{ attr }" do
          questions.each_with_index do |question, i|
            expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/#{ i }/#{ attr }")
          end
        end
      end

      it 'question object contain short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end
    end
  end

  describe 'GET #show' do
    context 'unauthorized' do
      let(:question) { create(:question) }
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token no vailid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:question)  { create(:question, :with_attachment) }
      let(:attachment) { question.attachments.first }
      let!(:comment)   { create(:comment, commentable: question) }

      before { get "/api/v1/questions/#{ question.id }", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{ attr }" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{ attr }")
        end
      end


      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{ attr }" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{ attr }")
          end
        end
      end

      context 'attachment' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

        it 'contain id' do
          expect(response.body).to be_json_eql(attachment.id.to_json).at_path("question/attachments/0/id")
        end

        it 'contain url in file' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/file/url")
        end
      end
    end
  end

  describe 'GET #answer' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/0/answers', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token no vailid' do
        get '/api/v1/questions/0/answers', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:question) { create(:question) }
      let!(:answers)  { create_list(:answer, 3, question: question) }
      let(:answer)    { answers.first }

      before { get "/api/v1/questions/#{ question.id }/answers", format: :json, access_token: access_token.token }

      it 'returns list of answers for question' do
        expect(response.body).to have_json_size(3)
      end
      # (*1)
      %w(id body created_at updated_at).each do |attr|
        it "contains #{ attr }" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{ attr }")
        end
      end
    end
  end
end
