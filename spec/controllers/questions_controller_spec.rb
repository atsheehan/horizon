require "rails_helper"

describe QuestionsController do
  let(:user) { FactoryGirl.create(:user) }

  describe "#destroy" do
    let(:question) { FactoryGirl.create(:question) }

    it 'sets the question visible attribute to false' do
      session[:user_id] = question.user.id
      expect(question.visible).to eq true

      delete :destroy, id: question.id
      expect(question.reload.visible).to eq false
    end
  end

  describe "#index" do
    it 'assigns a questions and filters instance variables' do
      questions = stub
      filtered = stub
      Question.stubs(:filtered).returns(filtered)
      QuestionDecorator.stubs(:decorate_collection).with(filtered).returns(questions)

      get :index, query: 'unanswered'
      expect(assigns(:questions)).to eq questions
      expect(assigns(:filter)).to eq 'unanswered'
    end
  end

  describe "PUT update" do
    it "allows original asker to accept an answer" do
      session[:user_id] = user.id

      question = FactoryGirl.create(:question, user: user)
      answer = FactoryGirl.create(:answer, question: question)

      put :update, id: question.id, question: {
        accepted_answer_id: answer.id
      }

      question.reload
      expect(question.accepted_answer).to eq(answer)
    end

    it "prevents other users from accepting answers" do
      session[:user_id] = user.id

      question = FactoryGirl.create(:question)
      answer = FactoryGirl.create(:answer, question: question)

      put :update, id: question.id, question: { accepted_answer_id: answer.id }

      question.reload
      expect(question.accepted_answer_id).to eq nil
    end
  end
end
