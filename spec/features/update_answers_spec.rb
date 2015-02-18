require "rails_helper"

feature "answering questions" do
  context "as a member" do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      sign_in_as(user)
    end

    scenario "accept an answer" do
      question = FactoryGirl.create(:question, user: user)
      answer = FactoryGirl.create(:answer, question: question)

      visit question_path(question)

      click_button "Accept Answer"

      expect(page).to have_content("Your question has been updated.")
      expect(page).to have_content("accepted answer")

      question.reload
      expect(question.accepted_answer).to eq(answer)
    end

    scenario "edit answer" do
      question = FactoryGirl.create(:question, user: user)
      FactoryGirl.create(:answer, question: question, user: user)

      visit question_path(question)

      click_on "Edit Answer"

      body = "No. A complete description of event horizons is not
      expected to, at minimum, require a theory of quantum gravity."

      fill_in "Answer", with: body

      click_button "Update Answer"

      expect(page).to have_content("Your answer has been updated.")
      expect(page).to have_content(body)
    end

    scenario "delete answer" do
      question = FactoryGirl.create(:question, user: user)
      answer = FactoryGirl.create(:answer, question: question, user: user)

      visit question_path(question)
      click_on "Delete Answer"

      expect(page).to_not have_content(answer.body)
    end
  end
end
