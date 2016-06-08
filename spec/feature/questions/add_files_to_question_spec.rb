require 'feature_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
  } do

    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit new_question_path
    end

    scenario 'User can add file when ask question' do
      fill_in 'Title', with: 'TitleText'
      fill_in 'Body', with: 'BodyText'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Create'

      expect(page).to have_content 'spec_helper.rb'
    end
  end
