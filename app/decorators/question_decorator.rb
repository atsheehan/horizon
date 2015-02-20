class QuestionDecorator < Draper::Decorator
  delegate_all

  def display_total_votes
    h.content_tag(:div, object.total_votes, class: 'total_votes')
  end

  def upvote
    if h.current_user
      h.link_to(h.question_upvotes_path(object), method: :post, id: "upvote") do
        h.content_tag(:i, '', class: 'fi-arrow-up upvote')
      end
    else
      h.content_tag(:i, '', class: 'mam')
    end
  end

  def downvote
    if h.current_user
      h.link_to(h.question_downvotes_path(object), method: :post, id: "downvote") do
        h.content_tag(:i, '', class: 'fi-arrow-down downvote')
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
    h.current_user.role == 'admin' if h.current_user
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

  def accepted_answer_owned_by_current_user?(answer)
    answer.accepted? && object.user == h.current_user
  end

  def show?
    object.visible || h.current_user.try(:admin?)
  end
end
