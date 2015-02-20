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

  describe '#display_total_votes' do
    let(:question) { FactoryGirl.create(:question).decorate }

    it 'should display total votes' do
      result = question.display_total_votes
      markup = Capybara.string(result)
      expect(markup.text).to eql "0"
    end
  end

  describe '#upvote' do
    let(:question) { FactoryGirl.create(:question).decorate }

    context 'authorized user' do
      it 'displays link with arrow up' do
        helpers.stubs(:current_user).returns(FactoryGirl.create(:user))
        result = question.upvote
        markup = Capybara.string(result)
        expect(markup).to have_selector('i.upvote')
      end
    end

    context 'unauthorized user' do
      it 'displays empty <i> tag' do
        result = question.upvote
        markup = Capybara.string(result)
        expect(markup).to have_selector('i.mam')
      end
    end
  end

  describe '#downvote' do
    let(:question) { FactoryGirl.create(:question).decorate }

    context 'authorized user' do
      it 'displays link with arrow down' do
        helpers.stubs(:current_user).returns(FactoryGirl.create(:user))
        result = question.downvote
        markup = Capybara.string(result)
        expect(markup).to have_selector('i.downvote')
      end
    end

    context 'unauthorized user' do
      it 'displays empty <i> tag' do
        result = question.downvote
        markup = Capybara.string(result)
        expect(markup).to have_selector('i.mam')
      end
    end
  end
end
