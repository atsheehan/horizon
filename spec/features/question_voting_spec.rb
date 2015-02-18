require "rails_helper"

feature "question voting" do
  let(:question) { FactoryGirl.create(:question) }

  context "as a member" do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      sign_in_as(user)
    end

    scenario "upvote a question" do
      visit question_path(question)

      within '.question-votes' do
        find("#upvote").click
      end

      within '.question-votes .total_votes' do
        expect(page).to have_content "1"
      end
    end

    scenario "downvote a question" do
      visit question_path(question)

      within '.question-votes' do
        find("#downvote").click
      end

      within '.question-votes .total_votes' do
        expect(page).to have_content "-1"
      end
    end

    scenario "change upvote to downvote" do
      visit question_path(question)

      within '.question-votes' do
        find("#upvote").click
        find("#downvote").click
        find("#downvote").click
      end

      within '.question-votes .total_votes' do
        expect(page).to have_content "-1"
      end
    end
  end

  context 'as a visitor' do
    scenario "I do not see upvote/downvote arrows" do
      visit question_path(question)

      expect(page).to_not have_selector('#upvote')
      expect(page).to_not have_selector('#downvote')
    end

    scenario "I can see total votes a question has" do
      visit question_path(question)

      expect(page).to have_selector('.total_votes')
    end
  end
end
