class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable

  after_action :render_pub, only: :create

  respond_to :js

  authorize_resource

  def create
    authorize! :create, Comment
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id)))
  end

  private

  def load_comment
    @comment = Comment.find(params[:id])
  end

  private

  def set_commentable
    params[:commentable].singularize
  end

  def load_commentable
    @commentable = set_commentable.classify.constantize.find(params["#{set_commentable}_id"])
  end

  def render_pub
    PrivatePub.publish_to('/comments', comment: @comment.to_json) if @comment.persisted?
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
