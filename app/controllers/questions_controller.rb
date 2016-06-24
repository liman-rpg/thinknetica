class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [ :show, :edit, :update, :destroy ]

  respond_to :js, only: :update

  def index
    respond_with(@questions=Question.all)
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.order(best: :desc, created_at: :desc)
    respond_with(@question)
  end

  def new
    respond_with(@question=Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user_id: current_user.id)))
  end

  def update
    @question.update(question_params) if current_user.id == @question.user_id
    respond_with @question
  end

  def destroy
    @question.destroy
    respond_with @question
  end

  private

  def load_question
    @question=Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
