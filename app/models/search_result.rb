class SearchResult
  attr_reader :query, :type, :user

  def initialize(query, type, user)
    @query = query
    @type = type
    @user = user
  end

  def lessons
    !user.guest? ? filtered_lessons.visible_for(user) : filtered_lessons.public
  end

  def questions
    filter_for_lessons ? Question.none : searched_questions
  end

  def total
    lessons.count + questions.count
  end

  private

  def filtered_lessons
    type.present? ? filter_lessons_by_type : searched_lessons
  end

  def filter_lessons_by_type
    filter_for_questions ? Lesson.none : searched_lessons.type(type)
  end

  def filter_for_questions
    type == "question"
  end

  def filter_for_lessons
    type.present? && !filter_for_questions
  end

  def searched_lessons
    @searched_lessons ||= Lesson.search(query)
  end

  def searched_questions
    results = []
    Question.search(query).each { |question| results << question }
    Answer.search(query).each { |answer| results << answer.question }
    results
  end

end
