class AnnouncementsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, except: [:index, :show]

  def index
    @team = Team.find(params[:team_id])
    @announcement = Announcement.new
  end

  def create
    @team = Team.find(params[:team_id])
    @announcement = @team.announcements.build(announcement_params)

    if @announcement.dispatch
      flash[:info] = "Added announcement."
      redirect_to team_announcements_path(@team)
    else
      flash[:alert] = "Failed to add announcement."
      render :index
    end
  end

  def show
    @announcement = current_user.announcements.find(params[:id])
  end

  def destroy
    announcement = Announcement.find(params[:id])

    announcement.destroy
    flash[:success] = "You have deleted an announcement."
    redirect_to root_path
  end

  private

  def announcement_params
    params.require(:announcement).permit(:title, :description)
  end
end
