require "rails_helper"

feature "view questions" do
  scenario "view the newest questions" do
    questions = FactoryGirl.create_list(:question, 3)

    visit questions_path

    expect(page).to have_content("Newest Questions")

    questions.each do |question|
      expect(page).to have_link(question.title, href: question_path(question))
    end
  end

  context "on index page" do
    scenario "question displays default 0 votes" do
      FactoryGirl.create(:question)

      visit questions_path

      within '.vote-count' do
        expect(page).to have_content("0")
      end
    end

    scenario "questions display number of upvotes on index page" do
      user = FactoryGirl.create(:user)
      question_with_vote = FactoryGirl.create(:question)
      question_with_vote.increment_vote(user)
      question_with_vote.reload

      visit questions_path

      within '.vote-count' do
        expect(page).to have_content("1")
      end
    end
  end
end
