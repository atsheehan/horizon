class AnswerDecorator < Draper::Decorator
  delegate_all

  def display_upvote
    if !h.current_user.guest?
      h.link_to(h.answer_upvotes_path(object), method: :post, id: "upvote") do
        h.content_tag(:i, '', class: "fi-arrow-up upvote #{upvote_cast?}")
      end
    end
  end

  def display_downvote
    if !h.current_user.guest?
      h.link_to(h.answer_downvotes_path(object), method: :post, id: "downvote") do
        h.content_tag(:i, '', class: "fi-arrow-down downvote #{downvote_cast?}")
      end
    end
  end

  def display_total_votes
    h.content_tag(:div, object.total_votes, class: 'total_votes')
  end

  private

  def upvote_cast?
    vote = h.current_user.votes.find_by(votable_id: object.id, votable_type: "Answer")
    vote.try(:upvote_cast?) ? "cast" : ""
  end

  def downvote_cast?
    vote = h.current_user.votes.find_by(votable_id: object.id, votable_type: "Answer")
    vote.try(:downvote_cast?) ? "cast" : ""
  end
end
