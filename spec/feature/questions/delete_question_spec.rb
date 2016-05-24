require 'feature_helper'

feature 'Delete question', %q{
  Authenticate user
  I want to delete question
} do
  given (:users) { create_list(:user, 2) }
  given(:question) { create(:question, user: users[0]) }

  scenario "Authenticate user try delete him question" do
    sign_in(users[0])
    question
    visit question_path(question)
    click_on 'Delete Question'

    expect(page).to have_content "Question was successfully destroyed."
    expect(current_path).to eq questions_path
    #Нужно проверять, что Qustion.count изменился?
  end

  scenario "Authenticate user try delete not him question" do
    sign_in(users[1])
    question
    visit question_path(question)

    expect(page).to_not have_link 'Delete Question'
  end

  scenario 'non-authenticated user try delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete Question'
  end
end
