require 'rails_helper'

describe Votable do
  let(:question) { FactoryGirl.create(:question) }
  let(:user) { FactoryGirl.create(:user) }

  describe '#total_votes' do

    it 'sums the total votes' do
      Vote.create(votable_id: question.id,
                  votable_type: "Question",
                  user_id: user.id,
                  score: 1)
      expect(question.total_votes).to eq 1
    end
  end

  describe '#increment_vote' do
    it 'adds 1 to score' do
      question.increment_vote(user)
      expect(question.votes.first.score).to eq 1
    end
  end

  describe '#decrement_vote' do
    it 'decreases 1 from score' do
      question.increment_vote(user)
      expect(question.votes.first.score).to eq 1

      question.decrement_vote(user)
      question.decrement_vote(user)
      expect(question.votes.first.score).to eq -1
    end
  end

  describe '#vote_question' do
    let(:question) { FactoryGirl.create(:question) }

    context 'given a question' do
      it 'returns itself' do
        vote = FactoryGirl.create(:vote, votable_id: question.id, votable_type: "Question")
        expect(question.vote_question).to eq question
      end
    end

    context 'given a answer' do
      it 'returns itself' do
        answer = FactoryGirl.create(:answer, question: question)
        vote = FactoryGirl.create(:vote, votable_id: question.id, votable_type: "Question")
        expect(answer.vote_question).to eq question
      end
    end
  end
end
