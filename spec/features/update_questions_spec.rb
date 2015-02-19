require "rails_helper"

feature "modifying questions" do

  context "as a visitor" do

  end

  context "as a member" do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      sign_in_as(user)
    end

    scenario "delete question" do
      question = FactoryGirl.create(:question, user: user)
      visit question_path(question)

      click_on "Delete question"
      expect(page).to have_content("Successfully deleted question")
      expect(page).to_not have_content(question.title)
    end

    scenario "can't delete other people's questions" do
      question = FactoryGirl.create(:question)
      visit question_path(question)

      expect(page).to_not have_content("Delete question")
    end

    scenario "un-accept an answer" do
      question = FactoryGirl.create(:question, user: user)
      FactoryGirl.create(:answer, question: question)
      visit question_path(question)

      click_on "Accept Answer"
      expect(page).to have_content("accepted answer")

      click_on "Unaccept answer"
      expect(page).to have_content("Your question has been updated.")
    end
    scenario "change accepted answer"
  end
end
