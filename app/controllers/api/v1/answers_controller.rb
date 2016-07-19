class Api::V1::AnswersController < Api::V1::BaseController
  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end
end
