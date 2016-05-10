require 'rails_helper'

feature 'Create answer', %q{
  In order to get answer from questions
  I want to create answer
} do
  given(:question) { create(:question) }

  scenario 'Can to create answer' do
    visit question_path(question)
    fill_in 'Ответ', with: 'BodyTestAnswer'
    click_on 'Reply'

    expect(page).to have_content 'BodyTestAnswer'
    expect(page).to have_content 'Ответ'
    expect(current_path).to eq question_path(question)
  end
end
