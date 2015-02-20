module Notifications
  class FlowDock
    FROM_SOURCE = 'Launch-Staff'
    EMAIL = 'hello@launchacademy.com'

    def initialize(*args)
      @message_args = args.first
      @flow = Flowdock::Flow.new(
        api_token: token,
        source: FROM_SOURCE,
        from: {
          name: FROM_SOURCE,
          address: EMAIL
        }
      )
    end

    def push_to_chat
      @flow.push_to_chat(
        content:  @message_args[:content],
        external_user_name: @message_args[:external_user_name]
      )
    end

    protected
    def token
      if Rails.env.development? || Rails.env.test?
        ENV['FLOWDOCK_TEST_TOKEN']
      else
        ENV['FLOWDOCK_TOKEN']
      end
    end
  end
end
