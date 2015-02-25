module Feedster
  class AssignmentCreatedDecorator < Feedster::Decorator
    def title
      assignment.lesson.title
    end

    def body
      'This is the assingment body'
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
