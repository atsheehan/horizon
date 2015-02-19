module QuestionsHelper
  def questions_header(filter)
    if filter == "newest"
      "Newest Questions"
    elsif filter == "unanswered"
      "Unanswered Questions"
    end
  end
end
