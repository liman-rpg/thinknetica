require 'rails_helper'

feature 'Show questions_path page', %q{
  The customer can view a list of questions
  The customer can choose an interesting question, and to link it
} do
  given(:question) { create(:question) }
  scenario 'Show #index' do

    visit questions_path

    expect(page).to have_content 'Questions list :'
    expect(current_path).to eq questions_path
  end
end
