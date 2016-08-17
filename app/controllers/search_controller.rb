class SearchController < ApplicationController
  SEARCH = %w{ anywhere, users, questions, answers, comments }

  def find
    if query == 'anywhere'
      @content = ThinkingSphinx.search params[:query]
    elsif query
      @content = query.classify.constantize.search params[:query]
    else
      redirect_to root_url
    end
  end

  private

  def query
    search_type = SEARCH
    search_type.include?(params[:search_type]) ? params[:search_type] : nil
  end
end
