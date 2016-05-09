require "rails_helper"

feature 'Create question', %q{
  In order to get answer from communiti
  I want to be able to ask question
} do
  given (:question) { create(:question) }
  scenario 'Can to create question' do

    visit questions_path
    click_on 'Add question'
    visit new_question_path
    fill_in 'Title', with: 'TitleText'
    fill_in 'Body', with: 'BodyText'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'

    #Не пойму, если поставить visit question_path(question) выше have_content выдает ошибку:
    # Failure/Error: expect(page).to have_content 'Your question successfully created.'
    #   expected to find text "Your question successfully created." in ""
    visit question_path(question)
    expect(current_path).to eq question_path(question)
  end
end


