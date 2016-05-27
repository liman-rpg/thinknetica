class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :load_answer, only: [ :edit, :update, :destroy ]
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
    @answer.destroy
    redirect_to @answer.question, notice: "Answer was successfully destroyed."
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
