require "rails_helper"

describe QuestionsController do
  let(:user) { FactoryGirl.create(:user) }

  describe "#index" do
    context 'query param is unanswered' do
      it 'only returns unanswered questions and sets filter to unanswered' do
        unanswered = double
        allow(Question).to receive(:unanswered).and_return(unanswered)
        allow(QuestionDecorator).
          to receive(:decorate_collection).and_return(unanswered)
        get :index, query: 'unanswered'
        expect(assigns(:questions)).to eq unanswered
        expect(assigns(:filter)).to eq 'unanswered'
      end
    end

    context 'query param is queued' do
      it 'only returns queued questions and sets filter to queued' do
        queued = double
        unsorted_queue = double(sort_by: queued)
        allow(Question).to receive(:queued).and_return(unsorted_queue)
        allow(QuestionDecorator).to receive(:decorate_collection).
          and_return(queued)
        get :index, query: 'queued'
        expect(assigns(:questions)).to eq queued
        expect(assigns(:filter)).to eq 'queued'
      end
    end

    context 'query param not passed' do
      it 'returns * questions orderedby created at and sets filter to newest' do
        newest = double
        allow(Question).
          to receive(:order).
          with(created_at: :desc).
          and_return(newest)
        allow(QuestionDecorator).
          to receive(:decorate_collection).and_return(newest)
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
