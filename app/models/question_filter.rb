class QuestionFilter
  CATEGORIES = ["Code syntax", "Code review", "Problem breakdown", "Best practices", "Other"]

  def initialize(query)
    @query = query
  end

  def filter
    if newest?
      Question.order(created_at: :desc)
    elsif unanswered?
      Question.unanswered
    elsif queued?
      Question.queued.sort_by { |q| q.question_queue.sort_order }
    else
      Question.where(category: @query).order(created_at: :desc)
    end
  end

  private

  def newest?
    @query == "newest"
  end

  def unanswered?
    @query == "unanswered"
  end

  def queued?
    @query == "queued"
  end
end
