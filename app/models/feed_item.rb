class FeedItem < ActiveRecord::Base
  belongs_to :subject,
    polymorphic: true

  belongs_to :recipient,
    foreign_key: "recipient_id",
    class_name: "User"

  belongs_to :actor,
    foreign_key: "actor_id",
    class_name: "User"

  validates :subject,
    presence: true

  validates :recipient,
    presence: true

  validates :verb,
    presence: true
end
