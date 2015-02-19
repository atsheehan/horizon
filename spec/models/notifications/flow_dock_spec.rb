require 'rails_helper'

describe Notifications::FlowDock, :vcr do
  describe '#initialize' do
    it 'creates a FlowDock::Flow' do
      Flowdock::Flow.expects(:new).with(
        api_token: ENV['FLOWDOCK_TEST_TOKEN'],
        source: described_class::FROM_SOURCE,
        from: {
          name: described_class::FROM_SOURCE,
          address: described_class::EMAIL
        }
      )
      Notifications::FlowDock.new
    end
  end

  describe '#push_to_chat' do
    it 'call the push_to_chat on the FlowDock::Flow' do
      flow = mock
      Flowdock::Flow.stubs(:new).returns(flow)

      flow_dock = Notifications::FlowDock.new(
        content: 'Make sure to read this reading!',
        external_user_name: 'SpencerCDixon'
      )

      flow.expects(:push_to_chat).with(
        content: 'Make sure to read this reading!',
        external_user_name: 'SpencerCDixon'
      )

      flow_dock.push_to_chat
    end
  end
end
