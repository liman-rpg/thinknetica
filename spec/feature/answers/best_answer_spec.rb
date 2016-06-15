require 'rails_helper'

feature 'Best Answer', %q{
  In order to choise the best answer
  as a question owner
  I want set answer as a Best
} do
  given(:user)     { create_list(:user, 2) }
  given(:question) { create(:question, user: user[0]) }
  given!(:answer1) { create(:answer, question: question, user: user[0]) }
  given!(:answer2) { create(:answer, question: question, user: user[0], best: false) }


  scenario 'Authenticate user & author question sees link_to Best Answer', js: true do
    sign_in(user[0])
    visit question_path(question)

    within '.answers' do
      expect(page).to have_link 'Set Best Answer'
    end
  end

  scenario "Authenticate user but not author question don't sees link_to Best Answer", js: true do
    sign_in(user[1])
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Set Best Answer'
    end
  end

  scenario "Best Answer first in the list", js: true do
    sign_in(user[0])
    visit question_path(question)

    within "#answer-id-#{ answer1.id }" do
      click_on 'Set Best Answer'

      expect(page).to_not have_link 'Set Best Answer'
      expect(page).to have_content 'Best Answer'
    end

    within '.answers' do
      expect(page.first('div')[:id]).to eq "answer-id-#{answer1.id}"
    end

    within "#answer-id-#{ answer2.id }" do
      click_on 'Set Best Answer'

      expect(page).to_not have_link 'Set Best Answer'
      expect(page).to have_content 'Best Answer'
    end

    within '.answers' do
      expect(page.first('div')[:id]).to eq "answer-id-#{answer2.id}"
    end

  end

  scenario "Unauthenticate don't sees link_to Best Answer", js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Set Best Answer'
    end
  end
end
