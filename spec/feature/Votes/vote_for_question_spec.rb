require 'feature_helper'

feature 'User can vote', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to vote
  } do
    given(:user) { create(:user) }
    given(:question) { create(:question) }

    scenario 'Authenticated users can vote for their favorite question'
    scenario 'Authenticated users can not vote for own question'
    scenario 'Authenticated users can vote "up" or "down" a particular question only once'
    scenario 'Authenticated users can cancel its decision and then revote'

  end
