require 'rails_helper'

feature 'Students deletes a question' do
  let(:student) { FactoryGirl.create(:user, role: "member")}
  let(:experience_engineer) { FactoryGirl.create(:user, role: "admin")}
  let(:question) { FactoryGirl.create(:question, title: "Question Header", user: student)}

  scenario 'Student can no longer see the question but EE can see it' do
    sign_in_as student
    visit question_path(question)
    click_on "Delete question"

    expect(page).to have_content "Newest Questions"
    expect(page).to have_content "Successfully deleted question"
    expect(page).not_to have_content "Question Header"

    sign_out
    sign_in_as experience_engineer
    visit questions_path

    expect(page).to have_content "Question Header"
  end

  scenario 'EE can delete a question that a student created' do
    sign_in_as experience_engineer
    visit question_path(question)

    click_on "Delete question"
    expect(page).to have_selector(".deleted-question")
    expect(page).to have_content "Question Header"
  end
end
