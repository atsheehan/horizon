module Feedster
  module Actor
    extend ActiveSupport::Concern

    included do
      has_many :generated_feed_items,
        foreign_key: 'actor_id',
        class_name: 'FeedItem',
        dependent: :destroy
    end
  end
end
