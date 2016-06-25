require 'feature_helper'

feature 'user can comment question', %q{
  In order to illustrate my question
  As an authenticated user
  I'd like to add comment for question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  describe 'Signed in User' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comment', js: true do
      within '.question .comments-question' do
        fill_in 'comment_body', with: 'TestBody'
        click_on 'Submit'

        expect(page).to have_content 'TestBody'
      end
    end

    scenario 'view content', js: true do
      within '.question .comments-question' do
          expect(page).to have_content 'Comments'
          expect(page).to have_button 'Submit'
        end
    end

    scenario 'add invalid comment', js: true do
      within '.question .comments-question' do
        fill_in 'comment_body', with: nil
        click_on 'Submit'

        expect(page).to_not have_content 'TestBody'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end
end
