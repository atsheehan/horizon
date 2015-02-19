module AnswerVotingHelper
  def display_upvote(user, answer)
    if user
      link_to(answer_upvotes_path(answer), method: :post, id: "upvote") do
        content_tag(:i, '', class: 'fi-arrow-up upvote')
      end
    end
  end

  def display_downvote(user, answer)
    if user
      link_to(answer_downvotes_path(answer), method: :post, id: "downvote") do
        content_tag(:i, '', class: 'fi-arrow-down downvote')
      end
    end
  end

  def display_total_votes(answer)
    content_tag(:div, answer.total_votes, class: 'total_votes')
  end
end
