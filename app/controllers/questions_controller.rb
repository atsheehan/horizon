class QuestionsController < ApplicationController
  def index
    if params[:query] == "unanswered"
      questions = []
      Question.all.each do |q|
        if q.answers.count == 0
          questions << q
        end
      end
      @questions = questions
    else
      @questions = Question.all
    end
  end

  def show
    @question = Question.find(params[:id])
    @answer = Answer.new
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
