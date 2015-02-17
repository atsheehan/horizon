require 'rails_helper'

describe DownvotesController do
  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:votable) { double }
    let(:already_voted) { true }
    let(:question) { FactoryGirl.create(:question) }

    context 'authenticated user' do
      before do
        session[:user_id] = user.id
        allow(Vote).to receive(:derive_votable).and_return(votable)
        allow(votable).to receive(:decrement_vote).with(user).and_return(already_voted)
        allow(votable).to receive(:vote_question).and_return(question)
      end

      context 'has already voted' do
        let(:already_voted) { false }

        it 'sets a failure message' do
          post :create, question_id: question.id
          expect(flash[:alert]).to eq 'You have already downvoted.'
        end
      end

      context 'has not already voted' do
        let(:already_voted) { true }

        it 'sets the success flash' do
          post :create, question_id: 1
          expect(flash[:success]).to eq 'Downvote saved.'
        end
      end

      it 'redirects_to the question_path' do
        post :create, question_id: question.id
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'unauthorized user' do
      it 'redirects_to the question_path' do
        post :create, question_id: question.id
        expect(flash[:info]).to eq "You need to sign in before continuing."
      end
    end
  end
end
