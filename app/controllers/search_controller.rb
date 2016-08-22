class SearchController < ApplicationController
  SEARCH_OPTION = [['anywhere', 'anywhere'],
                   ['users', 'users'],
                   ['questions', 'questions'],
                   ['answers', 'answers'],
                   ['comments', 'comments']]

  def find
    if options == 'anywhere' && !params[:query].empty?
      @content = ThinkingSphinx.search query
    elsif options && !params[:query].empty?
      @content = options.classify.constantize.search query
    else
      redirect_to root_url
      # @content = ''
    end
  end

  private

  def options
    options_for_select = %{ anywhere, users, questions, answers, comments }
    options_for_select.include?(params[:search_type]) ? params[:search_type] : nil
  end

  def query
    ThinkingSphinx::Query.escape(params[:query])
  end
end
