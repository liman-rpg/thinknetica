class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [ :show, :edit, :update, :destroy ]

  def index
    @questions=Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers.order(best: :desc, created_at: :desc)
  end

  def new
    @question=Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question=current_user.questions.new(question_params)

    if @question.save
      redirect_to @question , notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.id == @question.user_id
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Question was successfully destroyed.'

  end

  private

  def load_question
    @question=Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
