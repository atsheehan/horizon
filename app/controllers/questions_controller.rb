class QuestionsController < ApplicationController
  def index
    if params[:query] == "unanswered"
      @questions = Question.unanswered
      @filter = "unanswered"
    elsif params[:query] == "queued"
      @questions = Question.queued.sort_by { |q| q.question_queue.sort_order }
      @filter = "queued"
    else
      @questions = Question.order(created_at: :desc)
      @filter = "newest"
    end
    @questions = QuestionDecorator.decorate_collection(@questions)
  end

  def show
    @question = Question.find(params[:id]).decorate
    @answer = Answer.new
    @question_comment = QuestionComment.new
    @question_comments = @question.question_comments.limit(30)
    @answer_comment = AnswerComment.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(create_params)
    @question.user = current_user
    @question.save

    if @question.save
      flash[:info] = "Question saved."
      redirect_to question_path(@question)
    else
      flash[:alert] = "Failed to save question."
      render :new
    end
  end

  def update
    question = current_user.questions.find(params[:id])
    question.update(update_params)
    redirect_to question_path(question), info: "Your question has been updated."
  end

  def destroy
    @question = current_user.questions.find(params[:id])
    @question.destroy
    redirect_to questions_path, info: "Successfully deleted question"
  end

  def edit
    @question = Question.find(params[:id])
  end

  private

  def create_params
    params.require(:question).permit(:title, :body)
  end

  def update_params
    params.require(:question).permit(:accepted_answer_id, :title, :body)
  end
end
