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
    question = Question.find(params[:question_id])
    watching = current_user.question_watchings.where(question: question)
    watching.first.destroy
    redirect_to questions_path, info: "Stopped watching question."
  end
end
