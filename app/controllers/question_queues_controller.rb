class QuestionQueuesController < ApplicationController
  before_action :authorize_admin!, only: [:update, :create]

  def create
    @question = Question.find(params[:question_id])
    @question.queue

    redirect_to questions_path(@question)
  end

  def update
    @question_queue = QuestionQueue.find(params[:id])
    @question_queue.
      update_in_queue(question_queue_params[:status], current_user)

    redirect_to questions_path(query: 'queued')
  end

  private

  def question_queue_params
    params.require(:question_queue).permit(:status)
  end
end
