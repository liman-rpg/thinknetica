require 'feature_helper'

feature 'User can sign in with Facebook', %q{
  In order to be able to enjoy the full-service site
  As an User
  I want to be able to sign in
} do
  given(:user) { create(:user) }

  scenario 'user try sign_in with valid data' do
    visit new_user_registration_path
    facebook_mock_auth_hash
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account'
  end

  scenario 'user try sign_in with invalid data' do
    visit new_user_session_path
    facebook_mock_invalid_auth_hash

    click_on 'Sign in with Facebook'

    expect(page).to have_content('Could not authenticate you from Facebook')
  end
end
