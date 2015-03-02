module Feedster
  module Subject
    extend ActiveSupport::Concern

    included do
      has_many :feed_items,
        as: :subject,
        dependent: :destroy
      class_attribute :feed_generator_config
      self.feed_generator_config = {}
      after_save :generate_feed_items
    end

    module ClassMethods
      def generates_feed_item(verb, options = {})
        self.feed_generator_config[verb] = {
          actor_proc: options[:actor],
          recipients_proc: options[:recipients]
        }
      end
    end

    protected
    def generate_feed_items
      self.feed_generator_config.each do |verb, config|
        if verb == :create && self.id_changed?
          actor = nil
          if config[:actor_proc].present?
            actor = config[:actor_proc].call(self)
          end
          recipients = config[:recipients_proc].call(self)
          recipients.each do |recipient|
            self.feed_items.create! do |feed_item|
              feed_item.verb = verb
              feed_item.actor = actor
              feed_item.recipient = recipient
            end
          end
        end
      end
    end
  end
end
