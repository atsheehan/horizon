require 'rails_helper'

describe AnswerDecorator do
  describe '#display_total_votes' do
    let(:answer) { FactoryGirl.create(:answer).decorate }

    it 'should display total votes' do
      result = answer.display_total_votes
      markup = Capybara.string(result)
      expect(markup.text).to eql "0"
    end
  end

  describe '#display_upvote' do
    let(:answer) { FactoryGirl.create(:answer).decorate }

    context 'authorized user' do
      it 'displays link with arrow up' do
        helpers.stubs(:current_user).returns(FactoryGirl.create(:user))
        result = answer.display_upvote
        markup = Capybara.string(result)
        expect(markup).to have_selector('i.upvote')
      end
    end

    context 'unauthorized user' do
      it 'displays empty <i> tag' do
        expect(answer.display_downvote).to be nil
      end
    end
  end

  describe '#display_downvote' do
    let(:answer) { FactoryGirl.create(:answer).decorate }

    context 'authorized user' do
      it 'displays link with arrow down' do
        helpers.stubs(:current_user).returns(FactoryGirl.create(:user))
        result = answer.display_downvote
        markup = Capybara.string(result)
        expect(markup).to have_selector('i.downvote')
      end
    end

    context 'unauthorized user' do
      it 'displays empty <i> tag' do
        expect(answer.display_downvote).to be nil
      end
    end
  end
end
