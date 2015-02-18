require 'rails_helper'

feature 'Queue Index' do
  let(:ee) { FactoryGirl.create(:admin, name: 'Joe Shoe') }

  scenario "I can take a Question through the Question Queue" do
    student = FactoryGirl.create(:user)
    question = FactoryGirl.create(:question, user: student, title: 'What is the meaning to life?')

    sign_in_as ee
    visit question_path(question)
    click_on "Let's Talk!"

    click_on 'Question Queue'
    expect(page).to have_content(student.name)
    expect(page).to have_content('What is the meaning to life?')

    click_on "I'm on it!"
    expect(page).to have_content(ee.name)
    expect(page).to have_content("We Solved It!")

    click_on "We Solved It!"
    expect(page).not_to have_content("We Solved It!")
    expect(page).not_to have_content(question.title)
  end

  scenario "I can tag a question as a No Show to move it to the bottom of the queue" do
    student = FactoryGirl.create(:user)
    qq = FactoryGirl.create(:question_queue)
    question = FactoryGirl.create(:question, question_queue: qq, user: student, title: 'What is the meaning to life?')

    student2 = FactoryGirl.create(:user)
    qq2 = FactoryGirl.create(:question_queue)
    question2 = FactoryGirl.create(:question, question_queue: qq2, user: student2, title: 'Why does my postgresql not work????')

    sign_in_as ee
    visit questions_path(query: 'queued')

    expect(page.body.index('What is the meaning to life')).to be < page.body.index('Why does my postgresql not work')
    within("#queue_#{qq.id}") do
      click_on "No Show"
    end
    expect(page.body.index('Why does my postgresql not work')).to be < page.body.index('What is the meaning to life')

    visit questions_path
    expect(page).to have_content("Queued")
  end

  scenario "3 no shows marks a question as done" do
    student = FactoryGirl.create(:user)
    qq = FactoryGirl.create(:question_queue)
    question = FactoryGirl.create(:question, question_queue: qq, user: student, title: 'What is the meaning to life?')

    sign_in_as ee
    visit questions_path(query: 'queued')
    click_on "No Show"
    click_on "No Show"
    click_on "No Show"
    expect(page).to_not have_content('What is the meaning to life?')
  end
end
