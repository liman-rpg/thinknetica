require 'rails_helper'

feature 'Remove files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be remove files
  } do
    given(:user) { create(:user) }

    scenario "Authenticate user as author of question try remove question's file form" do
      sign_in(user)
      visit new_question_path

      within all('.nested-fields').first do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

        expect(page).to_not have_content 'spec_helper.rb'

        click_link 'Remove form', "#{Rails.root}/spec/spec_helper.rb"
      end

      within '.attachments-form' do
        expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end
  end
