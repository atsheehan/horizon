class SearchesController < ApplicationController
  def index
    @active_type = params[:type]
    @lessons = filter_lessons(current_user, params[:query])
    @questions = filter_questions(params[:query])
    @results = (@lessons + @questions).length
  end

  private

  def filter_lessons(user, query)
    lessons = Lesson.search(query)
    lessons = type_filter(params[:type], lessons)
    user ? lessons.visible_for(user) : lessons.public
  end

  def type_filter(type, lessons)
    if type
      type != "question" ? lessons.type(type) : Lesson.none
    else
      lessons
    end
  end

  def filter_questions(query)
    results = []
    Question.search(query).each { |question| results << question }
    Answer.search(query).each { |answer| results << answer.question }
    if params[:type]
      params[:type] == "question" ? results : []
    else
      results
    end
  end
end
