class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!, only: [:index]

  def index
    @ratings = Rating.order(:created_at).page(params[:page])
  end

  def create
    @lesson = Lesson.find_by!(slug: params[:lesson_slug])
    @rating = @lesson.ratings.build(rating_params)
    @rating.user = current_user

    if @rating.save
      flash[:info] = "Rating saved."
      redirect_to @lesson
    else
      flash[:alert] = "Rating could not be saved."
      render "lessons/show"
    end
  end

  def update
    @lesson = Lesson.find_by!(slug: params[:lesson_slug])
    @rating = @lesson.ratings.find_by!(user: current_user, id: params[:id])

    if @rating.update(rating_params)
      flash[:info] = "Rating updated."
      redirect_to @lesson
    else
      flash[:alert] = "Rating could not be updated."
      render "lessons/show"
    end
  end

  private

  def rating_params
    params.require(:rating).permit(:clarity, :helpfulness, :comment)
  end
end
