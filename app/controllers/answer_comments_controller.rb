class AnswerCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = Answer.find(params[:answer_id])
    @question = @answer.question
    @comment = @answer.answer_comments.new(answer_params)
    @comment.user = current_user
    if @comment.save
      redirect_to question_path(@question), info: "Comment saved."
    else
      errors = @comment.errors.full_messages.join
      redirect_to question_path(@question),
        alert: "Failed to save comment. #{errors}"
    end
  end

  def destroy
    comment = current_user.answer_comments.find(params[:id])
    comment.destroy
    redirect_to question_path(comment.answer.question),
      info: "Your comment has been deleted"
  end

  private

  def question_id
    params[:answer_comment].try(:[], :question_id)
  end

  def answer_params
    params.require(:answer_comment).permit(:body)
  end
end
