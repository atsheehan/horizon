require 'rails_helper'

feature 'accepting answers' do
  let(:user) { FactoryGirl.create(:user) }
  let(:question) { FactoryGirl.create(:question, user: user) }
  let!(:answer) { FactoryGirl.create(:answer, question: question) }

  scenario 'student accepting answer' do
    sign_in_as(user)
    visit question_path(question)
    click_button "Accept Answer"

    expect(page).to have_content("Question updated.")
    expect(page).to have_content("accepted answer")

    question.reload
    expect(question.accepted_answer).to eq(answer)
  end

  scenario 'admin accepting answer' do
    admin = FactoryGirl.create(:admin)

    sign_in_as(admin)
    visit question_path(question)
    click_button "Accept Answer"

    expect(page).to have_content("Question updated.")
    expect(page).to have_content("accepted answer")

    question.reload
    expect(question.accepted_answer).to eq(answer)
  end
end
