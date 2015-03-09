module Feedster
  class CommentCreatedDecorator < Feedster::Decorator
    def title
      link_to(actor.username, user_path(actor)) +
        'commented on your ' +
        link_to(submission.lesson.title + ' submission',
          submission_path(submission))
    end

    def body
      comment.html_body.html_safe
    end

    def created_at
      comment.created_at
    end

    protected
    def submission
      @feed_item.subject.submission
    end

    def comment
      @feed_item.subject
    end
  end
end
