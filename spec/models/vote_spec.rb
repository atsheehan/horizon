require 'rails_helper'

describe Vote do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }

  describe '#update_vote_cache' do
    context 'given a question' do
      it 'updates vote cache when vote is created' do
        expect(question.vote_cache).to eq 0
        question.increment_vote(user)

        expect(question.reload.vote_cache).to eq 1
      end
    end

    context 'given an answer' do
      let(:answer) { FactoryGirl.create(:answer, question: question) }

      it 'updates vote cache when vote is created' do
        expect(answer.vote_cache).to eq 0
        answer.increment_vote(user)

        expect(answer.reload.vote_cache).to eq 1
      end
    end
  end
end
