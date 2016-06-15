require 'rails_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
  } do
    given(:user) { create(:user) }
    given!(:question) { create(:question) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User can add files when ask answer', js: true do
      fill_in 'Ответ', with: 'BodyTestAnswer'

      all('input[type="file"]')[0].set "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Add file'
      all('input[type="file"]')[1].set "#{Rails.root}/spec/rails_helper.rb"
      # within all('.nested-fields').first do
      #   attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      # end

      # click_on 'Add file'

      # within all('.nested-fields').last do
      #   attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      # end

      click_on 'Reply'

      within '.answers' do
        expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
      end
    end
  end
