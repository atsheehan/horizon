class SearchesController < ApplicationController
  def index
    @lessons = filter_lessons(current_user, params[:query])
    @questions = filter_questions(params[:query])
    @results = (@lessons + @questions).length
  end

  private

  def filter_lessons(user, query)
    lesson = Lesson.search(query)
    user ? lesson.visible_for(user) : lesson.public
  end

  def filter_questions(query)
    results = []
    Question.search(query).each { |question| results << question }
    Answer.search(query).each { |answer| results << answer.question }
    results
  end
end
