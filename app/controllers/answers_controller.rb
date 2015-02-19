class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id]).decorate
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:info] = "Answer saved."
      redirect_to question_path(@question)
    else
      flash[:alert] = "Failed to save answer."
      redirect_to question_path(@question)
    end
  end

  def edit
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end

  def update
    answer = current_user.answers.find(params[:id])
    answer.update(answer_params)
    redirect_to question_path(answer.question),
      info: "Your answer has been updated."
  end

  def destroy
    answer = current_user.answers.find(params[:id])
    answer.destroy
    redirect_to question_path(answer.question),
      info: "Your answer has been deleted."
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
