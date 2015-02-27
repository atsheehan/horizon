module Feedster
  class DecoratorMappingNotFound < Exception; end;
  class DecoratedCollection
    def initialize(feed_items)
      @feed_items = feed_items
    end

    def decorate
      @feed_items.map do |feed_item|
        if decorator_map[feed_item.subject.class.name] &&
          decorator_map[feed_item.subject.class.name][feed_item.verb]

          decorator_map[feed_item.subject.class.name][feed_item.verb].new(feed_item)
        else
          raise Feedster::DecoratorMappingNotFound,
            "Decorator not found for #{feed_item.subject.class.name}: " +
            "#{feed_item.verb}"
        end
      end
    end

    protected
    def decorator_map
      @decorator_map ||= {
        'Comment' => {
          'create' => Feedster::CommentCreatedDecorator
        },
        'Assignment' => {
          'create' => Feedster::AssignmentCreatedDecorator
        },
        'Announcement' => {
          'create' => Feedster::AnnouncementCreatedDecorator
        }
      }
    end
  end
end

