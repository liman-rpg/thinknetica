require 'rails_helper'

feature 'Show question with answers', %q{
  The customer can view question & him answers
} do

  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'Show question #show' do
    answer

    visit questions_path

    expect(page).to have_content question.title

    click_on question.title
    visit question_path(question)

    expect(current_path).to eq question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
  end
end
