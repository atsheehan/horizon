class SearchesController < ApplicationController
  def index
    search_result = SearchResult.new(params[:query], params[:type], current_user)

    @active_type = search_result.type
    @lessons = search_result.lessons
    @questions = search_result.questions
    @results = search_result.total
  end
end
