require 'rails_helper'

describe QuestionQueuesController do
  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:team) { FactoryGirl.create(:team) }
    let(:question) { FactoryGirl.create(:question, user: user) }
    let(:experience_engineer) { FactoryGirl.create(:admin) }

    before do
      FactoryGirl.create(:team_membership, user: user, team: team)
    end

    context 'as an admin' do
      before do
        session[:user_id] = experience_engineer.id
      end

      it 'redirects to the question#show route' do
        post :create, question_id: question.id
        expect(response).to redirect_to(questions_path(question))
      end

      it 'calls the queue method on the question' do
        question = stub(id: 1)
        Question.stubs(:find).returns(question)
        question.expects(:queue)

        post :create, question_id: question.id
      end
    end

    context 'as any other user' do
      it 'redirects to the question#show route' do
        session[:user_id] = user.id

        expect { post :create, question_id: question.id }.
          to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe '#update' do
    let(:user) { FactoryGirl.create(:user) }
    let(:question_queue) { FactoryGirl.create(:question_queue) }
    let(:question) do
      FactoryGirl.create(:question, question_queue: question_queue, user: user)
    end
    let(:experience_engineer) { FactoryGirl.create(:admin) }

    before(:each) do
      session[:user_id] = experience_engineer.id
    end

    it 'redirects to the queue index' do
      patch :update,
        id: question_queue.id,
        question_queue: { status: 'in-progress' }
      expect(response).to redirect_to(questions_path(query: 'queued'))
    end

    it 'calls update_in_queue with proper args' do
      question_queue = stub(id: 1)
      QuestionQueue.stubs(:find).returns(question_queue)
      question_queue.expects(:update_in_queue).with('no-show', experience_engineer)

      patch :update,
        id: question_queue.id,
        question_queue: { status: 'no-show' }
    end
  end
end
