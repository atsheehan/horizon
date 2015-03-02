module Feedster
  class AnnouncementCreatedDecorator < Feedster::Decorator
    def title
      content_tag(:i, '', class: 'fi-alert announcement-feed') +
        'Staff Announcement: '.html_safe +
        link_to(announcement.title, announcement_path(announcement))
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
