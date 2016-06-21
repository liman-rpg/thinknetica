class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :load_answer, only: [ :edit, :update, :destroy, :set_best_answer ]
  before_action :load_question, only: [ :create ]

  def new
    @answer=Answer.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user=current_user

    respond_to do |format|
      if @answer.save
        format.js
      else
        format.js
      end
    end
  end

  def update
      @answer.update(answer_params) if current_user.id == @answer.user_id
      @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.id == @answer.user_id
  end

  def set_best_answer
    @answer.set_as_best! if @answer.question.user_id == current_user.id
    @answers = @answer.question.answers.order(best: :desc, created_at: :desc) if @answer.best?
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
