class Announcement < ActiveRecord::Base
  belongs_to :team
  has_many :announcement_receipts

  validates :team, presence: true
  validates :title, presence: true
  validates :description, presence: true

  include Feedster::Subject
  generates_feed_item :create,
    actor: ->(c) { User.admins.first }, # story to fix this actor
    recipients: ->(c) { c.team.users }

  def dispatch
    if save
      Notifications::AnnouncementNotification.new(self).dispatch
      true
    else
      false
    end
  end
end
