class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @upcoming_assignments = current_user.assignments.order(due_on: :asc)
    @announcements = current_user.announcements.order(created_at: :desc).limit(5)
    @feed_items = Feedster::DecoratedCollection.new(
      current_user.received_feed_items.order('created_at DESC').limit(25)).decorate

  end
end
