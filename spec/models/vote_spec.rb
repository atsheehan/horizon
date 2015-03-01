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

  describe 'vote helpers' do
    let(:vote) { FactoryGirl.create(:vote, score: score, votable_id: question.id, votable_type: "Question") }

    describe "upvote_cast?" do
      context 'downvote cast' do
        let(:score) { -1 }

        it 'returns false' do
          expect(vote.upvote_cast?).to eq false
        end
      end

      context 'no vote cast' do
        let(:score) { 0 }

        it 'returns false' do
          expect(vote.upvote_cast?).to eq false
        end
      end

      context 'upvote cast' do
        let(:score) { 1 }

        it 'returns true' do
          expect(vote.upvote_cast?).to eq true
        end
      end
    end

    describe "downvote_cast?" do
      context 'downvote cast' do
        let(:score) { -1 }

        it 'returns true' do
          expect(vote.downvote_cast?).to eq true
        end
      end

      context 'no vote cast' do
        let(:score) { 0 }

        it 'returns false' do
          expect(vote.downvote_cast?).to eq false
        end
      end

      context 'upvote cast' do
        let(:score) { 1 }

        it 'returns false' do
          expect(vote.downvote_cast?).to eq false
        end
      end
    end

    describe "#can_upvote?" do
      context 'downvote cast' do
        let(:score) { -1 }

        it 'returns true' do
          expect(vote.can_upvote?).to eq true
        end
      end

      context 'no vote cast' do
        let(:score) { 0 }

        it 'returns true' do
          expect(vote.can_upvote?).to eq true
        end
      end

      context 'upvote cast' do
        let(:score) { 1 }

        it 'returns false' do
          expect(vote.can_upvote?).to eq false
        end
      end
    end

    describe "#can_downvote?" do
      context 'downvote cast' do
        let(:score) { -1 }

        it 'returns false' do
          expect(vote.can_downvote?).to eq false
        end
      end

      context 'no vote cast' do
        let(:score) { 0 }

        it 'returns true' do
          expect(vote.can_downvote?).to eq true
        end
      end

      context 'upvote cast' do
        let(:score) { 1 }

        it 'returns true' do
          expect(vote.can_downvote?).to eq true
        end
      end
    end
  end
end
