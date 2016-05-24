require 'feature_helper'

feature 'Show question with answers', %q{
  The customer can view question & him answers
} do
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 2, question: question) }

  scenario 'Show question #show' do
    answers
    visit questions_path
    click_on question.title

    expect(current_path).to eq question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answers[0].body
    expect(page).to have_content answers[1].body
  end
end
