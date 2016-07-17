require 'rails_helper'

describe 'Profile API' do
  describe 'GET /questions' do
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
  end

  context 'authorized' do
    let(:access_token) { create(:access_token) }
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

    context 'answers' do
      it 'included in question object' do
        expect(response.body).to have_json_size(1).at_path("questions/0/answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{ attr }" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{ attr }")
        end
      end
    end
  end
end
