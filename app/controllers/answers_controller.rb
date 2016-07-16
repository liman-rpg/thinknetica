class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :load_answer, only: [ :edit, :update, :destroy, :set_best_answer ]
  before_action :load_question, only: [ :create ]

  respond_to :js

  authorize_resource

  def new
    respond_with(@answer = Answer.new)
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    @answer.destroy
    respond_with @answer
  end

  def set_best_answer
    @answer.set_as_best! if @answer.question.user_id == current_user.id
    @answers = @answer.question.answers.order(best: :desc, created_at: :desc) if @answer.best?
    respond_with @answer
  end

  private

  def load_answer
    @answer=Answer.find(params[:id])
  end

  def load_question
    @question=Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
