require 'rails_helper'

describe UpvotesController do
  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:votable) { stub }
    let(:already_voted) { true }
    let(:question) { FactoryGirl.create(:question) }

    context 'authenticated user' do
      before do
        session[:user_id] = user.id
        Vote.stubs(:derive_votable).returns(votable)
        votable.stubs(:increment_vote).with(user).returns(already_voted)
        votable.stubs(:vote_question).returns(question)
      end

      context 'has already voted' do
        let(:already_voted) { false }

        it 'sets a failure message' do
          post :create, question_id: question.id
          expect(flash[:alert]).to eq 'You have already upvoted.'
        end
      end

      context 'has not already voted' do
        let(:already_voted) { true }

        it 'sets the success flash' do
          post :create, question_id: 1
          expect(flash[:success]).to eq 'Upvote saved.'
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
