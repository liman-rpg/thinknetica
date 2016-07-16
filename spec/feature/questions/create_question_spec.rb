require "feature_helper"

feature 'Create question', %q{
  In order to get answer from communiti
  Authenticate user
  I want to create question
} do
  given (:user) { create(:user) }

  scenario 'Authenticate user try create question' do
    sign_in(user)

    visit questions_path
    click_on 'Add question'
    visit new_question_path
    fill_in 'Title', with: 'TitleText'
    fill_in 'Body', with: 'BodyText'
    click_on 'Create'

    expect(page).to have_content "Question was successfully created."
    expect(page).to have_content 'TitleText'
    expect(page).to have_content 'BodyText'
  end

  scenario 'Unauthenticate user try create question' do
    visit questions_path

    expect(page).to_not have_content 'Add question'
  end
end


