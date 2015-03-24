class QuestionsController < ApplicationController
  def index
    @filter = params[:query] || 'newest'
    @questions = QuestionDecorator.decorate_collection(Question.filtered(@filter))
  end

  def show
    @question = Question.find(params[:id]).decorate
    @answers = AnswerDecorator.decorate_collection(@question.sorted_answers)
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

    if @question.save
      @question.add_watcher(current_user)
      flash[:info] = "Question saved."
      redirect_to question_path(@question)
    else
      flash[:alert] = "Failed to save question."
      render :new
    end
  end

  def update
    question = Question.find(params[:id])

    if current_user.can_edit?(question)
      question.update(update_params)
      redirect_to question_path(question), info: "Question updated."
    else
      redirect_to question_path(question), alert: "You don't have access to edit this."
    end
  end

  def destroy
    @question = Question.find(params[:id])

    if current_user.can_edit?(@question)
      @question.update_attributes(visible: false)
      redirect_to questions_path, info: "Successfully deleted question"
    else
      redirect_to questions_path, alert: "You don't have access to delete this."
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  private

  def create_params
    params.require(:question).permit(:title, :body, :category)
  end

  def update_params
    params.require(:question).permit(:accepted_answer_id, :title, :body, :category)
  end
end
