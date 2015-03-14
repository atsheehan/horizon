require 'rails_helper'

feature 'answer voting' do
  let(:answer) { FactoryGirl.create(:answer) }
  let(:question) { answer.question }

  context 'as a member' do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      sign_in_as(user)
      visit question_path(question)
    end

    scenario 'upvote an answer' do
      within '.answer-votes' do
        find('#upvote').click
      end

      within '.answer-votes .total_votes' do
        expect(page).to have_content "1"
      end
    end

    scenario 'downvote an answer' do
      within '.answer-votes' do
        find('#downvote').click
      end

      within '.answer-votes .total_votes' do
        expect(page).to have_content "-1"
      end
    end

    scenario 'change upvote to downvote' do
      within '.answer-votes' do
        find('#upvote').click
      end

      within '.answer-votes' do
        find('#downvote').click
        find('#downvote').click
      end

      within '.answer-votes .total_votes' do
        expect(page).to have_content "-1"
      end
    end
  end

  context 'as a visitor' do
    scenario 'I can see total votes an answer has' do
      visit question_path(question)

      expect(page).to have_selector('.total_votes')
    end

    scenario 'I do not see upvote/downvote arrows' do
      visit question_path(question)

      expect(page).to_not have_selector('.upvote')
      expect(page).to_not have_selector('.downvote')
    end
  end
end
