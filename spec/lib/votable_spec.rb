require 'rails_helper'

describe Votable do
  describe '#total_votes' do
    it 'sums the total votes'
  end

  describe '#increment_vote' do
    it 'adds 1 to score'
  end

  describe '#decrement_vote' do
    it 'decreases 1 from score'
  end

  describe '#question' do
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
