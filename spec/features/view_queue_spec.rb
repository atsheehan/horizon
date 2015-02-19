require 'rails_helper'

feature 'viewing questions in the Queue' do
  let(:student) { FactoryGirl.create(:user) }
  let(:ee) { FactoryGirl.create(:user, name: 'Joe Shoe') }

  scenario 'I can see Question Queue status on Questions' do
    qq1 = FactoryGirl.create(:question_queue, status: 'done')
    qq2 = FactoryGirl.create(:question_queue, status: 'open')
    qq3 = FactoryGirl.create(:question_queue, status: 'in-progress', user: ee)
    FactoryGirl.create(:question, question_queue: qq1)
    FactoryGirl.create(:question, question_queue: qq2)
    FactoryGirl.create(:question, question_queue: qq3)

    sign_in_as student
    visit questions_path
    click_on 'Question Queue'

    visit questions_path
    expect(page).to have_content("Queued")
    expect(page).to have_content("Assigned to Joe Shoe")
    expect(page).to have_content("Done")
  end
end
