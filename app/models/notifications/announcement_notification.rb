module Notifications
  class AnnouncementNotification

    def initialize(announcement)
      @announcement = announcement
    end

    def dispatch
      Notifications::FlowDock.new(
        content: content,
        external_user_name: external_user_name
      ).push_to_chat
    end

    private

    def content
      "@everyone, #{@announcement.title}: #{@announcement.description}"
    end

    def external_user_name
      "Launch-Staff"
    end
  end
end
