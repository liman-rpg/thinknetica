class AnswersController < ApplicationController
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
    @answer.save
  end

  def update
      @answer.update(answer_params) if current_user.id == @answer.user_id
      @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.id == @answer.user_id
  end

  def set_best_answer
    question = @answer.question
    if current_user.id == question.user_id
      Answer.set_as_best(@answer)
      @answers = question.answers.order(best: :desc, created_at: :desc)
    end
  end

  private

  def load_answer
    @answer=Answer.find(params[:id])
  end

  def load_question
    @question=Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
