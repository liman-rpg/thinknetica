require 'rails_helper'

shared_examples_for "voted" do
  model = controller_class.controller_path.singularize

  let(:votable) { create(model.to_sym) }

  describe 'POST #vote_up' do
    sign_in_user
    before { post :vote_up, id: votable, status: true }

    context 'Not author try voting' do
      it 'Score value +1' do
        expect(votable.votes.first.score).to eq 1
      end

      it "render json with ratable id, score and true status" do
        expect(response.body).to eq ({ id: votable.id, score: votable.total, status: true }).to_json
      end
    end

    context 'if user is author of votable' do
      let(:votable) { create(model.to_sym, user: @user) }

      it "doesn't create vote" do
        expect(votable.votes.count).to eq 0
      end

      it 'redirect_to root_url' do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe '#vote_down' do
    sign_in_user
    before { post :vote_down, id: votable, status: true }

    context 'Not author try voting' do
      it 'Score value -1' do
        expect(votable.votes.first.score).to eq -1
      end

      it "render json with ratable id, score and true status" do
        expect(response.body).to eq ({ id: votable.id, score: votable.total, status: true }).to_json
      end
    end

    context 'if user is author of votable' do
      let(:votable) { create(model.to_sym, user: @user) }

      it "doesn't create vote" do
        expect(votable.votes.count).to eq 0
      end

      it 'redirect_to root_url' do
        expect(response).to redirect_to root_url
      end
    end
  end

  describe '#vote_cancel'
    sign_in_user
    before { post :vote_cancel, id: votable, status: false }

    context 'Not author try reset' do
      it 'Score value 0' do
        expect(votable.votes.count).to eq 0
      end

      it "render json with ratable id, score and true status" do
        expect(response.body).to eq ({ id: votable.id, score: votable.total, status: false }).to_json
      end
    end

    context 'if user is author of votable' do
      let(:votable) { create(model.to_sym, user: @user) }

      it "doesn't create vote" do
        expect(votable.votes.count).to eq 0
      end

      it 'redirect_to root_url' do
        expect(response).to redirect_to root_url
      end
    end

end
