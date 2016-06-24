require 'feature_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
  } do
    given(:user) { create(:user) }
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question, user: user) }

    scenario "Authenticate user as author of answer try remove answer's file form" do
      sign_in(user)
      visit question_path(question)

      within all('.nested-fields').first do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"

        expect(page).to_not have_content 'spec_helper.rb'

        click_link 'Remove form', "#{Rails.root}/spec/spec_helper.rb"
      end

      within '.attachments-answer' do
        expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      end
    end
  end
