require 'rails_helper'

describe Notifications::AnnouncementNotification do
  describe '#dispatch' do

    it 'sends a formated message to the flowdock wrapper' do
      flow_dock = mock
      announcement = FactoryGirl.create(:announcement)

      Notifications::FlowDock.
        expects(:new).
        with(
          content:
          "@everyone, #{announcement.title}: #{announcement.description}",
          external_user_name: "Launch-Staff"
        ).
        returns(flow_dock)
        flow_dock.expects(:push_to_chat)
        Notifications::AnnouncementNotification.new(announcement).dispatch
    end
  end
end
