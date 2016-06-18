module Voted
  extend ActiveSupport::Concern

  included do
    before_action :get_votable, only: [ :vote_up, :vote_down, :vote_cancel ]
    before_action :not_owner, only: [ :vote_up, :vote_down, :vote_cancel ]
  end

  def vote_up
    @votable.vote_up(current_user)
    render json: { id: @votable.id, score: @votable.total }
  end

  def vote_down
    @votable.vote_down(current_user)
    render json: { id: @votable.id, score: @votable.total }
  end

  def vote_cancel
    @votable.vote_cancel(current_user)
    render json: { id: @votable.id, score: @votable.total }
  end

  private

  def get_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def not_owner
    render nothing: true, status: 403 if @votable.user_id == current_user.id
  end

end
