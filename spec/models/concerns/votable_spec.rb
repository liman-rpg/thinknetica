require 'rails_helper'

shared_examples_for "votable" do
  let(:model) { described_class }
  let(:votable) { create(model.to_s.underscore.to_sym) }
  let(:user) { create(:user) }

  describe '#vote_up' do
    it 'create new vote with score = 1' do
      expect { votable.vote_up(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.score).to eq 1
    end
  end

  describe '#vote_down' do
    it 'create new vote with score = -1' do
      expect { votable.vote_down(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.first.score).to eq -1
    end
  end

  describe '#vote_cancel' do
    let!(:vote) { create(:vote, votable: votable, user: user) }

    it 'delete vote from database' do
      votable.vote_cancel(user)
      expect(votable.votes.count).to eq 0
    end
  end

  describe '#total' do
    it 'return sum of score all votes for current question' do
      create_list(:vote, 5, :up, votable: votable)
      expect(votable.votes.count).to eq 5
    end
  end
end
