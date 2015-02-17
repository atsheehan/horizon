require 'rails_helper'

describe QuestionDecorator do
  include Draper::ViewHelpers

  describe '#accepted_answer_owned_by_current_user?' do
    let(:author) { FactoryGirl.create(:user) }
    let(:question) { FactoryGirl.create(:question, user: author).decorate }
    let(:answer) { double(accepted?: true) }

    context 'answer is accepted' do
      context 'user owns question' do
        it 'should return true' do
          allow(helpers).to receive(:current_user).and_return(author)
          expect(question.accepted_answer_owned_by_current_user?(answer)).
            to eq true
        end
      end

      context 'user does not own question' do
        it 'should return false' do
          allow(helpers).to receive(:current_user).and_return(FactoryGirl.
              create(:user))
          expect(question.accepted_answer_owned_by_current_user?(answer)).
            to eq false
        end
      end
    end

    context 'answer is not accepted' do
      it 'should return false' do
        answer = double(accepted?: false)
        expect(question.accepted_answer_owned_by_current_user?(answer)).
          to eq false
      end
    end
  end
end
