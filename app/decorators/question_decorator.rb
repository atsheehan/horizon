class QuestionDecorator < Draper::Decorator
  delegate_all

  def display_total_votes
    h.content_tag(:div, object.total_votes, class: 'total_votes')
  end

  def upvote
    if !h.current_user.guest?
      h.link_to(h.question_upvotes_path(object), method: :post, id: "upvote") do
        h.content_tag(:i, '', class: "fi-arrow-up upvote #{upvote_cast?}")
      end
    else
      h.content_tag(:i, '', class: 'mam')
    end
  end

  def downvote
    if !h.current_user.guest?
      h.link_to(h.question_downvotes_path(object), method: :post, id: "downvote") do
        h.content_tag(:i, '', class: "fi-arrow-down downvote #{downvote_cast?}")
      end
    else
      h.content_tag(:i, '', class: 'mam')
    end
  end

  def queue_id
    "queue_#{object.question_queue.id}"
  end

  def queue_progress
    'queue-number' + (object.question_queue.status == 'in-progress' ? ' in-progress' : '')
  end

  def assignee
    if object.question_queue.user.present?
      "#{object.question_queue.user.name} is assigned to this question."
    else
      "This Question has been assigned"
    end
  end

  def in_queue?
    object.question_queue.present? && h.params[:query] == 'queued'
  end

  def admin_access?
    h.current_user.role == 'admin' if !h.current_user.guest?
  end

  def open?
    object.question_queue.status == 'open'
  end

  def in_progress?
    object.question_queue.status == "in-progress"
  end

  def queue_status
    if object.question_queue.present?
      h.content_tag(
        :small, object.question_queue.status_text,
        class: "queue-status #{object.question_queue.status}"
      )
    end
  end

  def can_unaccept?
    can_accept? && object.accepted_answer.try(:accepted?)
  end

  def can_accept?
    h.current_user.try(:admin?) || h.current_user == object.user
  end

  def show?
    object.visible || h.current_user.try(:admin?)
  end

  private

  def upvote_cast?
    vote = h.current_user.votes.find_by(votable_id: object.id, votable_type: "Question")
    vote.try(:upvote_cast?) ? "cast" : ""
  end

  def downvote_cast?
    vote = h.current_user.votes.find_by(votable_id: object.id, votable_type: "Question")
    vote.try(:downvote_cast?) ? "cast" : ""
  end
end
