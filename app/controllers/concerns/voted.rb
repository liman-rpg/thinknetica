module Voted
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [ :vote_up, :vote_down, :vote_cancel ]
  end

  def vote_up
    authorize! :vote_up, @votable
    @votable.vote_up(current_user)
    render json: { id: @votable.id, score: @votable.total, status: true }
  end

  def vote_down
    authorize! :vote_down, @votable
    @votable.vote_down(current_user)
    render json: { id: @votable.id, score: @votable.total, status: true }
  end

  def vote_cancel
    authorize! :vote_cancel, @votable
    @votable.vote_cancel(current_user)
    render json: { id: @votable.id, score: @votable.total, status: false }
  end

  private

  def get_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
