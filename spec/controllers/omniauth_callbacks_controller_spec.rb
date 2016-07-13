require 'rails_helper'
 RSpec.describe OmniauthCallbacksController, type: :controller do
  describe "GET #facebook" do
    let(:user) { create(:user) }

    before { @request.env["devise.mapping"] = Devise.mappings[:user] }

    context 'user does not exit' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: 'facebook', uid: '123456789', info: { email: 'test@test.com' } })
        get :facebook
      end

      it 'user sign_in' do
        should be_user_signed_in
      end

    end

    context 'user a new' do
      let(:auth){ create(:authorization, user: user) }

      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: auth.provider, uid: auth.uid, info: { email: user.email } })
        get :facebook
      end

      it 'user sign_in' do
        should be_user_signed_in
      end
    end
  end

  describe "GET #twitter" do
    let(:user) { create(:user) }
    before { @request.env["devise.mapping"] = Devise.mappings[:user] }

    context 'user does not exit' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: 'twitter', uid: '123456789', info: { email: 'new-user@email.com' } })
        get :twitter
      end

      it 'user sign_in' do
        should be_user_signed_in
      end
    end

    context 'user a new' do
      let(:auth){ create(:authorization, user: user) }

      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: auth.provider, uid: auth.uid, info: { email: user.email } })
        get :twitter
      end

      it 'user sign_in' do
        should be_user_signed_in
      end
    end

    context 'Confirm email ' do
      before do
        request.env['omniauth.auth'] = OmniAuth::AuthHash.new({ provider: 'twitter', uid: '123456789', info: { email: nil } })
        get :twitter
      end

      it { should_not be_user_signed_in }
      it { should redirect_to confirm_email_for_auth_path }
    end
  end
end
