module Feedster
  class Decorator
    include ActionView::Helpers
    include EventHorizon::Application.routes.url_helpers

    def initialize(feed_item)
      @feed_item = feed_item
    end

    def title
      raise 'you must override this method'
    end

    def body
      raise 'you must override this method'
    end

    protected
    def actor
      @feed_item.actor
    end
  end
end
