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
    context 'query param is unanswered' do
      it 'only returns unanswered questions and sets filter to unanswered' do
        unanswered = stub
        Question.stubs(:unanswerd).returns(unanswered)
        QuestionDecorator.stubs(:decorate_collection).returns(unanswered)
        get :index, query: 'unanswered'
        expect(assigns(:questions)).to eq unanswered
        expect(assigns(:filter)).to eq 'unanswered'
      end
    end

    context 'query param is queued' do
      it 'only returns queued questions and sets filter to queued' do
        question_queue = stub
        questions = stub
        queued = stub(sort_by: questions)
        Question.stubs(:queued).returns(queued)
        QuestionDecorator.stubs(:decorate_collection).with(questions).returns(question_queue)

        get :index, query: 'queued'
        expect(assigns(:questions)).to eq question_queue
        expect(assigns(:filter)).to eq 'queued'
      end
    end

    context 'query param not passed' do
      it 'returns * questions orderedby created at and sets filter to newest' do
        newest = stub
        Question.stubs(:order).with(created_at: :desc).returns(newest)
        QuestionDecorator.stubs(:decorate_collection).returns(newest)
        get :index
        expect(assigns(:questions)).to eq newest
        expect(assigns(:filter)).to eq 'newest'
      end
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

      expect {
        put :update, id: question.id, question: {
          accepted_answer_id: answer.id
        }
      }.to raise_error(ActiveRecord::RecordNotFound)

      question.reload
      expect(question.accepted_answer).to_not eq(answer)
    end
  end
end
