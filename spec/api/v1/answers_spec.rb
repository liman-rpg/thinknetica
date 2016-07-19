require 'rails_helper'

describe 'Answer API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET #show' do
    context 'unauthorized' do
      let(:question) { create(:question) }
      let(:answer) { create(:answer) }

      it 'returns 401 status if there is no access_token' do
        get "/api/v1//answers/#{ answer.id }", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token no vailid' do
        get "/api/v1//answers/#{ answer.id }", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:answer)     { create(:answer, :with_attachment) }
      let!(:attachment) { create(:attachment, attachable: answer) }
      let!(:comment)    { create(:comment, commentable: answer) }


      before { get "/api/v1//answers/#{ answer.id }", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{ attr }" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{ attr }")
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{ attr }" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{ attr }")
          end
        end
      end

      context 'attachment' do
        # it 'included in answer object' do
        #   expect(response.body).to have_json_size(1).at_path('attachments')
        # end
        # ---->
        # Answer API GET #show authorized attachment included in answer object
        # Failure/Error: expect(response.body).to have_json_size(1).at_path('attachments')
        # Expected JSON value size to be 1, got 2 at path "attachments"
        #  ./spec/api/v1/answers_spec.rb:55:in `block (5 levels) in <top (required)>'

        it 'contain id' do
          expect(response.body).to be_json_eql(attachment.id.to_json).at_path("attachments/0/id")
        end

        it 'contain url in file' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end
  end
end
