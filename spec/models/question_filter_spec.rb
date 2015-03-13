require 'rails_helper'

describe QuestionFilter do
  describe "#filter" do
    context 'deafult (nil)' do
      it 'returns newest questions' do
        old_question = FactoryGirl.create(:question, created_at: 4.days.ago)
        new_question = FactoryGirl.create(:question)

        expect(QuestionFilter.new('newest').filter).to eq [new_question, old_question]
      end
    end

    context 'unanswered' do
      it 'returns unanswered questions' do
        answered = FactoryGirl.create(:answer).question
        unanswered_question = FactoryGirl.create(:question)

        expect(QuestionFilter.new('unanswered').filter.first).to eq (unanswered_question)
        expect(QuestionFilter.new('unanswered').filter.first).to_not eq (answered)
      end
    end

    context 'queued' do
      it 'returns all queued questions' do
        not_queued = FactoryGirl.create(:question)
        queued = FactoryGirl.create(:question, question_queue: FactoryGirl.create(:question_queue))

        expect(QuestionFilter.new('queued').filter.first).to eq (queued)
        expect(QuestionFilter.new('queued').filter.first).to_not eq (not_queued)
      end
    end

    context 'category filter' do
      it "returns quesitons with 'other' category" do
        other = FactoryGirl.create(:question, category: 'Other')
        review = FactoryGirl.create(:question, category: 'Code review')

        expect(QuestionFilter.new('Other').filter.first).to eq (other)
        expect(QuestionFilter.new('Other').filter.first).to_not eq (review)
      end
    end
  end
end
