class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :load_question, only: [ :show, :answers ]

  def index
    @questions = Question.all
    respond_with @questions, each_serializer: QuestionCollectionSerializer
  end

  def show
    respond_with @question
  end

  def answers
    # иначе в спеках при проверке answers, первый answer будет последним (*1)
    respond_with @question.answers.order( created_at: :asc )
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end
end
