require 'sphinx_helper'

feature 'user can search for something', '
  In order to get fast access to data
  anybody
  can find
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, title: 'Title Sphinx', user: user) }

  background do
    index
    visit root_path
  end

  scenario 'Question' do
    within '.search' do
      fill_in 'search', with: 'Sphinx'
      page.select 'questions', from: 'search_type'
      click_on 'Find'
    end
    save_and_open_page
    expect(page).to have_content question.title
  end
end
