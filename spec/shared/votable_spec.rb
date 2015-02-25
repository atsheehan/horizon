require 'rails_helper'

shared_examples "a votable object" do
  let(:symbol) { described_class.to_s.downcase.to_sym }
  let(:object) { FactoryGirl.create(symbol) }
  let(:user) { FactoryGirl.create(:user) }

  describe '#total_votes' do
    it 'sums the total votes' do
      Vote.create(votable_id: object.id,
                  votable_type: object.class.to_s,
                  user_id: user.id,
                  score: 1)
      expect(object.total_votes).to eq 1
    end
  end

  describe '#increment_vote' do
    it 'adds 1 to score' do
      object.increment_vote(user)
      expect(object.votes.first.score).to eq 1
    end
  end

  describe '#decrement_vote' do
    it 'decreases 1 from score' do
      object.increment_vote(user)
      expect(object.votes.first.score).to eq 1

      object.decrement_vote(user)
      object.decrement_vote(user)
      expect(object.votes.first.score).to eq -1
    end
  end

  describe '#vote_question' do
    it 'returns itself the associated question' do
      FactoryGirl.create(:vote, votable_id: object.id, votable_type: "Question")
      expect(object.vote_question.class.to_s).to eq "Question"
    end
  end
end
