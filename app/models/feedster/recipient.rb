module Feedster
  module Recipient
    extend ActiveSupport::Concern

    included do
      has_many :received_feed_items,
        foreign_key: 'recipient_id',
        class_name: 'FeedItem',
        dependent: :destroy
    end
  end
end
