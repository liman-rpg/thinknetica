require 'rails_helper'

feature 'Create answer', %q{
  In order to get answer from questions
  Authenticate user
  I want to create answer
} do
  given!(:question) { create(:question, user: user) }
  given (:user) { create(:user) }

  describe 'Authenticate user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'try create answer', js: true do
      fill_in 'Ответ', with: 'BodyTestAnswer'
      click_on 'Reply'

      expect(page).to have_content 'BodyTestAnswer'
      expect(page).to have_content 'Ответ'
      expect(current_path).to eq question_path(question)
    end

    scenario 'try create nill answer', js: true do
      fill_in 'Ответ', with: ''
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'try create short answer (:body)', js: true do
      fill_in 'Ответ', with: 'SML'
      click_on 'Reply'

      expect(page).to have_content "Body is too short (minimum is 5 characters)"
    end
  end

  scenario 'Unauthenticate user try create answer' do
    visit question_path(question)
    fill_in 'Ответ', with: 'BodyTestAnswer'
    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end
