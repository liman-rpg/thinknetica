require 'feature_helper'
require 'capybara/email/rspec'

feature 'User can login with twitter', %q{
  In order to sign in system
  As an non-authenticated user
  I want to login with twitter
} do
  scenario 'user try sign_in with valid data' do
    visit new_user_session_path
    twitter_mock_auth_hash

    clear_emails
    click_on 'Sign in with Twitter'

    fill_in 'Enter your email', with: 'test@test.com'
    click_on 'Confirm'

    expect(page).to have_content 'Log in'

    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
  end

  scenario 'user try sign_in with invalid data' do
    visit new_user_session_path

    twitter_mock_invalid_auth_hash
    click_on 'Sign in with Twitter'

    expect(page).to have_content('Could not authenticate you from Twitter')
  end
end
