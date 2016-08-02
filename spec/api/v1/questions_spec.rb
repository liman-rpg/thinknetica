require 'rails_helper'

describe 'Questions API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET #index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:questions)   { create_list(:question, 3) }
      let(:question)     { questions.first }
      let!(:answer)      { create(:answer, question: question) }

      before { do_request(access_token: access_token.token) }

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

    def do_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:question)  { create(:question, :with_attachment) }
      let(:attachment) { question.attachments.first }
      let!(:comment)   { create(:comment, commentable: question) }

      before { do_request(access_token: access_token.token) }

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
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'GET #answer' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:question) { create(:question) }
      let!(:answers)  { create_list(:answer, 3, question: question) }
      let(:answer)    { answers.first }

      before { get "/api/v1/questions/#{ question.id }/answers", format: :json, access_token: access_token.token }

      it 'returns list of answers for question' do
        expect(response.body).to have_json_size(3).at_path('answers')
      end
      # (*1)
      %w(id body created_at updated_at).each do |attr|
        it "contains #{ attr }" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{ attr }")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions/0/answers', { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      context 'question with vailid params' do
        let(:create_valid_question) { do_request(access_token: access_token.token, question: attributes_for(:question)) }
        let(:question_last) { Question.last }

        it 'save in database' do
          expect{ create_valid_question }.to change(Question, :count).by(1)
        end

        context 'after create' do
          before { create_valid_question }

          it 'returns 201 status' do
            expect(response).to be_success
          end

          %w(id title body created_at updated_at).each do |attr|
            it "contains #{ attr }" do
              create_valid_question
              expect(response.body).to be_json_eql(question_last.send(attr.to_sym).to_json).at_path("question/#{ attr }")
            end
          end

          it 'check attributes' do
            question_last.reload

            expect(question_last.title).to eq question_last[:title]
            expect(question_last.body).to eq "MyText"
            expect(question_last.user_id).to eq user.id
          end
        end
      end

      context 'question with invailid params' do
        let(:create_invalid_question) { do_request(access_token: access_token.token, question: attributes_for(:invalid_question)) }
        let(:question_last) { Question.last }

        it 'not save in database' do
          expect{ create_invalid_question }.to_not change(Question, :count)
        end

        context 'after create' do
          before { create_invalid_question }

          it 'returns 422 status' do
            expect(response.status).to eq 422
          end
        end
      end
    end

    def do_request(options = {})
      post '/api/v1/questions', { format: :json }.merge(options)
    end
  end
end
