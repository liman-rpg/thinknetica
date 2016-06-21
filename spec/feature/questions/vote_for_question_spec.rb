require 'feature_helper'

feature 'User can vote', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to vote
  } do
    given(:user_main) { create(:user) }
    given(:user_other) { create(:user) }
    given!(:question) { create(:question, user: user_main) }

    scenario 'Authenticated users can vote && reset for their favorite question', js: true do
      sign_in(user_other)
      visit question_path(question)

      within ".question" do
        expect(page).to have_content 'Votes:'
      end

      within ".question .votes_link" do
        click_on 'Up'

        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
        expect(page).to have_link 'Reset'
      end

      within ".question .votes_score" do
        expect(page).to have_content '1'
      end

      within ".question .votes_link" do
        click_on 'Reset'

        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'
        expect(page).to_not have_link 'Reset'
      end

      within ".question .votes_score" do
        expect(page).to have_content '0'
      end

      within ".question .votes_link" do
        click_on 'Down'

        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
        expect(page).to have_link 'Reset'
      end

      within ".question .votes_score" do
        expect(page).to have_content '-1'
      end
    end

    scenario 'Authenticated users can not vote for own question', js: true do
      sign_in(user_main)
      visit question_path(question)

      within ".question .votes_link" do
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
        expect(page).to_not have_link 'Reset'
      end
    end


    scenario 'Unauthenticated users can not voting' do
      visit question_path(question)

      within ".question .votes_link" do
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
        expect(page).to_not have_link 'Reset'
      end
    end
  end
