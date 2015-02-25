class QuestionCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id]).decorate
    @comment = @question.question_comments.new(comment_params)
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
    comment = current_user.question_comments.find(params[:id])
    comment.destroy
    redirect_to question_path(comment.question),
      info: "Your comment has been deleted"
  end

  private

  def comment_params
    params.require(:question_comment).permit(:body)
  end
end
