require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  sign_in_user

  describe 'POST #create' do
    let!(:question)            { create(:question) }
    let(:create_subscription) { post :create, id: question.id, subscriptable: 'Question', format: :js }

    context 'with valid attributes' do
      it 'save subscription in database' do
        expect { create_subscription }.to change(Subscription, :count).by(1)
      end

      it 'render create.js view' do
        create_subscription
        expect(response).to render_template :create
      end
    end
  end
end
