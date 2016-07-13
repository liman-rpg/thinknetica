require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  describe "GET #confirm_email" do
    it 'render template confirm_email_for_auth' do
      get :confirm_email

      expect(response).to render_template :confirm_email
    end
  end

  describe "POST #save_email" do
    before do
      session['devise.oauth_data'] = {provider: 'twitter', uid: '123456789'}
    end

    context 'with valid email' do
      it 'assigns user to User' do
        post :save_email, email: 'test@test.com'

        expect(assigns(:user)).to be_a(User)
      end

      it 'redirect_to new_user_session_path' do
        post :save_email, email: 'test@test.com'

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with invalid email' do
      it 'redirect_to confirm_email' do
        post :save_email, email: nil

        expect(response).to redirect_to confirm_email_for_auth_path
      end
    end
  end
end
