require 'rails_helper'

describe QuestionDecorator do
  include Draper::ViewHelpers

  describe '#accepted_answer_owned_by_current_user?' do
    let(:author) { FactoryGirl.create(:user) }
    let(:question) { FactoryGirl.create(:question, user: author).decorate }
    let(:answer) { stub(accepted?: true) }

    context 'answer is accepted' do
      context 'user owns question' do
        it 'should return true' do
          helpers.stubs(:current_user).returns(author)
          expect(question.accepted_answer_owned_by_current_user?(answer)).to eq true
        end
      end

      context 'user does not own question' do
        it 'should return false' do
          helpers.stubs(:current_user).returns(FactoryGirl.create(:user))
          expect(question.accepted_answer_owned_by_current_user?(answer)).to eq false
        end
      end
    end

    context 'answer is not accepted' do
      it 'should return false' do
        answer = stub(accepted?: false)
        expect(question.accepted_answer_owned_by_current_user?(answer)).to eq false
      end
    end
  end
end
