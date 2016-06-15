require 'rails_helper'

feature 'Delete answer', %q{
  Authenticate user
  I want to delete answer
} do
  given (:users) { create_list(:user, 2) }
  given(:question) { create(:question, user: users[0]) }
  given(:answer) { create(:answer, question: question, user: users[0]) }

  scenario 'Authenticate user try delete him answer', js: true do
    sign_in(users[0])
    answer
    visit question_path(question)
    click_on 'Delete Answer'

    expect(page).to have_content 'Your answer was deleted.'
    expect(current_path).to eq question_path(question)
  end

  scenario "Aauthenticate user try delete not him answer", js: true do
    sign_in(users[1])
    visit question_path(question)

    expect(page).to_not have_link 'Delete Answer'
  end

  scenario 'non-authenticated user try delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete Answer'
  end
end
