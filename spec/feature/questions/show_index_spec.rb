require 'rails_helper'

feature 'Show questions_path page', %q{
  The customer can view a list of questions
  The customer can choose an interesting question, and to link it
} do
  given(:questions) { create_list(:question, 2) }

  scenario 'Show #index' do
    questions
    visit questions_path

    expect(page).to have_content 'Questions list :'
    expect(current_path).to eq questions_path
    expect(page).to have_link(questions[0].title, href: question_path(questions[0]))
    expect(page).to have_link(questions[1].title, href: question_path(questions[1]))
  end
end
