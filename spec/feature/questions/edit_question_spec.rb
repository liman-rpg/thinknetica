require 'feature_helper'

feature "Edit question", %q{
  n order to get question from communiti
  Authenticate user
  I want to edit question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

    scenario 'Authenticate user sees link to edit question', js: true do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        expect(page).to have_link 'Edit Question'
      end
    end

    scenario 'Authenticate user try edit him question', js: true do
      sign_in(user)
      visit question_path(question)

      within '.question' do
        click_on 'Edit Question'
        fill_in 'Title', with: 'First edit Title'
        fill_in 'Body', with: 'First edit Body'
        click_on 'Save'

        expect(page).to have_content 'First edit Title'
        expect(page).to have_content 'First edit Body'
        expect(page).to_not have_content question.body
        expect(page).to_not have_content question.title
        expect(page).to_not have_selector 'textarea'

        click_on 'Edit Question'
        fill_in 'Title', with: 'Second edit Title'
        fill_in 'Body', with: 'Second edit Body'
        click_on 'Save'

        expect(page).to have_content 'Second edit Title'
        expect(page).to have_content 'Second edit Body'
        expect(page).to_not have_content 'First edit Title'
        expect(page).to_not have_content 'First edit Body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "Authenticate user try edit others user's question", js: true do
      sign_in(user)
      question = create(:question)
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit Question'
      end
    end

    scenario 'Unauthenticate user try edit question' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_link 'Edit Question'
      end
    end

end
