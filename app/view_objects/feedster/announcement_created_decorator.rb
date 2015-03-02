module Feedster
  class AnnouncementCreatedDecorator < Feedster::Decorator
    def title
      content_tag(:i, '', class: 'fi-alert announcement-feed') +
      'Staff Announcement: ' + announcement.title
    end

    def body
      announcement.description
    end

    def created_at
      announcement.created_at
    end

    protected
    def announcement
      @feed_item.subject
    end
  end
end
