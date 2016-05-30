require 'feature_helper'

feature 'Answer edit', %q{
  In order to fix mistake
  As Authenticate users
  i want edit answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticate user' do
    before do
      sign_in(user)
      answer
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within '.answers' do
        expect(page).to have_link "Edit"
      end
    end

    scenario 'try edit him answer', js: true do
      click_on 'Edit Answer'

      within '.answers' do
        fill_in 'Ответ', with: 'First Edit'
        click_on 'Reply'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'First Edit'
        expect(page).to_not have_selector 'textarea'
      end

      click_on 'Edit Answer'

      within '.answers' do
        fill_in 'Ответ', with: 'Second Edit'
        click_on 'Reply'

        expect(page).to_not have_content 'First Edit'
        expect(page).to have_content 'Second Edit'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "try edit other user's answer", js: true do
      click_on 'Delete Answer' #отчищаем список answers
      create(:answer, question: question)

      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  describe "Unauthenticate user", js: true do
    before do
      answer
      visit question_path(question)
    end

    scenario "try edit answer" do
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end
  end
end

