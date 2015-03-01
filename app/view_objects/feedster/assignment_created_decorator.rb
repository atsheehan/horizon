module Feedster
  class AssignmentCreatedDecorator < Feedster::Decorator
    def title
      content_tag(:i, '', class: 'fi-laptop assignment-feed') +
      assignment.lesson.title
    end

    def body
      assignment.lesson.description
    end

    def created_at
      assignment.created_at
    end

    protected
    def assignment
      @feed_item.subject
    end
  end
end
