require 'sphinx_helper'

feature 'user can search for something', '
  In order to get fast access to data
  anybody
  can find
', :js do

  given!(:user) { create(:user, email: 'sphinx@mail.ru') }
  given!(:question) { create(:question, title: 'Title Sphinx', user: user) }
  given!(:answer) { create(:answer, body: 'Body Sphinx', question: question) }
  given!(:comment) { create(:comment, body: 'Body Sphinx', commentable: question) }


  background do
    index
    visit root_path
  end

  scenario 'Search in Question model' do
    within '.search' do
      fill_in 'search', with: 'Sphinx'
      page.select 'questions', from: 'search_type'
      click_on 'Find'
    end

    expect(page).to have_content question.title
  end

  scenario 'Search in Answer model' do
    within '.search' do
      fill_in 'search', with: 'Sphinx'
      page.select 'answers', from: 'search_type'
      click_on 'Find'
    end

    expect(page).to have_content answer.body
  end

  scenario 'Search in Comment model' do
    within '.search' do
      fill_in 'search', with: 'Sphinx'
      page.select 'comments', from: 'search_type'
      click_on 'Find'
    end

    expect(page).to have_content comment.body
  end

  scenario 'Search in User model' do
    within '.search' do
      fill_in 'search', with: 'Sphinx'
      page.select 'users', from: 'search_type'
      click_on 'Find'
    end

    expect(page).to have_content user.email
  end

  scenario 'Search in Anywhere model' do
    within '.search' do
      fill_in 'search', with: 'Sphinx'
      page.select 'anywhere', from: 'search_type'
      click_on 'Find'
    end

    expect(page).to have_content user.email
    expect(page).to have_content question.title
    expect(page).to have_content answer.body
    expect(page).to have_content comment.body
  end

  scenario 'Search invalid query' do
    within '.search' do
      fill_in 'search', with: 'nothing'
      page.select 'anywhere', from: 'search_type'
      click_on 'Find'
    end

    expect(page).to have_content 'Search No results!'
  end
end
