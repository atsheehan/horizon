class AnswerDecorator < Draper::Decorator
  delegate_all

  def display_upvote
    if h.current_user
      h.link_to(h.answer_upvotes_path(object), method: :post, id: "upvote") do
        h.content_tag(:i, '', class: 'fi-arrow-up upvote')
      end
    end
  end

  def display_downvote
    if h.current_user
      h.link_to(h.answer_downvotes_path(object), method: :post, id: "downvote") do
        h.content_tag(:i, '', class: 'fi-arrow-down downvote')
      end
    end
  end

  def display_total_votes
    h.content_tag(:div, object.total_votes, class: 'total_votes')
  end
end
