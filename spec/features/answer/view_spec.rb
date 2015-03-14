require "rails_helper"

feature "answering questions" do
  context "as a member" do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      sign_in_as(user)
    end

    scenario "submit an answer successfully" do
      question = FactoryGirl.create(:question)

      visit question_path(question)

      fill_in "Answer", with: "You need to reticulate the splines."
      click_button "Submit Answer"

      expect(page).to have_content("Answer saved.")
      expect(page).to have_content("You need to reticulate the splines.")
      expect(page).to have_content("#{user.username} answered")

      expect(Answer.count).to eq(1)
    end

    scenario "display error when submitting a blank answer" do
      question = FactoryGirl.create(:question)

      visit question_path(question)
      click_button "Submit Answer"

      expect(page).to have_content("Failed to save answer.")
      expect(Answer.count).to eq(0)
    end
  end

  context "as an unauthenticated user" do
    scenario "should not see answer submission form" do
      question = FactoryGirl.create(:question)
      visit question_path(question)

      expect(page).to_not have_content("Answer Question")
      expect(page).to_not have_link("Submit Answer")
    end
  end
end
