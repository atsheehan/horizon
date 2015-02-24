class QuestionWatchingsController < ApplicationController
  before_action :authenticate_user!

  def create
    question = Question.find(params[:question_id])
    watching = current_user.question_watchings.new(question: question)

    if watching.save
      flash[:info] =  "Now watching question."
    end
    redirect_to questions_path
  end

  def destroy
    watching = current_user.question_watchings.find_by!(question_id: params[:question_id])
    if watching.destroy
      redirect_to questions_path, info: "Stopped watching question."
    else
      redirect_to questions_path, alert: "You're not watching that question."
    end
  end
end
