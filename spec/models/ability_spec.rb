require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admit' do
    let(:user) { create :user, admin: true}

    it { should be_able_to :menage, :all }
  end

  describe 'for user' do
    let(:user)                  { create :user }
    let(:other_user)            { create :user }
    let(:question)              { create(:question) }
    let(:question_user)         { create(:question, user: user) }
    let(:answer)                { create(:answer) }
    let(:answer_user)           { create(:answer, user: user) }
    let(:answer_user_question)  { create(:answer, question: question_user, user: user) }

    #don't admin capability
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'question' do
      #read
      it { should be_able_to :read, Question }
      #create
      it { should be_able_to :create, Question }
      #update
      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: other_user), user: user }
      #vote
      it { should be_able_to :vote_up, question, user: user }
      it { should be_able_to :vote_down, question, user: user }
      it { should be_able_to :vote_cancel, question, user: user }

      it { should_not be_able_to :vote_up, question_user, user: user }
      it { should_not be_able_to :vote_down, question_user, user: user }
      it { should_not be_able_to :vote_cancel, question_user, user: user }
      #destroy
      it { should be_able_to :destroy, question_user, user: user }

      it { should_not be_able_to :destroy, question, user: user }
    end

    context 'answer' do
      #read
      it { should be_able_to :read, Question }
      #create
      it { should be_able_to :create, Question }
      #update
      it { should be_able_to :update, create(:answer, user: user), user: user }

      it { should_not be_able_to :update, create(:answer, user: other_user), user: user }
      #set_best_answer
      it { should be_able_to :set_best_answer, answer_user_question, user: user }

      it { should_not be_able_to :set_best_answer, answer_user, user: user }
      #vote
      it { should be_able_to :vote_up, question, user: user }
      it { should be_able_to :vote_down, question, user: user }
      it { should be_able_to :vote_cancel, question, user: user }

      it { should_not be_able_to :vote_up, question_user, user: user }
      it { should_not be_able_to :vote_down, question_user, user: user }
      it { should_not be_able_to :vote_cancel, question_user, user: user }
      #destroy
      it { should be_able_to :destroy, answer_user, user: user }

      it { should_not be_able_to :destroy, answer, user: user }
    end

    context 'for comment' do
      #create
      it { should be_able_to :create, Comment }
    end

    context 'for attachment' do
      context 'to question' do
        let(:attachment) { create(:attachment, attachable: question) }
        let(:attachment_user) { create(:attachment, attachable: question_user) }
        #destroy
        it { should be_able_to :destroy, attachment_user, user: question_user }

        it { should_not be_able_to :destroy, attachment, user: user }
      end

      context 'to answer' do
        let(:attachment) { create(:attachment, attachable: answer) }
        let(:attachment_user) { create(:attachment, attachable: answer_user) }
        #destroy
        it { should be_able_to :destroy, attachment_user, user: answer_user }

        it { should_not be_able_to :destroy, attachment, user: user }
      end

    end
  end
end
