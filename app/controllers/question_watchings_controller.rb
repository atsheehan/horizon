class QuestionWatchingsController < ApplicationController
  before_action :authenticate_user!

  def create
    question = Question.find(params[:question_id])
    watching = current_user.question_watchings.new(question: question)
    if watching.save
      flash[:info] =  "Now watching question."
    else
      flash[:alert] = "Already watching question."
    end
    redirect_to questions_path
  end

  def destroy
    watching = current_user.question_watchings.
      find_by!(question_id: params[:question_id])
    if watching.destroy
      flash[:info] = "Stopped watching question."
    else
      flash[:alert] = "You're not watching that question."
    end
    redirect_to questions_path
  end
end
