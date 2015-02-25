class AnnouncementReceiptsController < ApplicationController
  def create
    @receipt = AnnouncementReceipt.new(
      announcement_id: params[:announcement_id])
    @receipt.user = current_user
    @receipt.save
    redirect_to dashboard_path
  end
end
