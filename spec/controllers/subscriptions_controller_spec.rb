require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  sign_in_user
  let!(:question) { create(:question) }

  describe 'POST #create' do
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

  describe 'DELETE #destroy' do
    let(:destroy_subscription) { delete :destroy, id: question.id, subscriptable: 'Question', format: :js }

    context 'if user subscription exists' do
      before { create(:subscription, subscriptable: question, user: @user) }

      it "delete user subscription from database" do
        expect { destroy_subscription }.to change(Subscription, :count).by(-1)
      end

      it "render destroy.js view" do
        destroy_subscription
        expect(response).to render_template :destroy
      end
    end
  end
end
