require 'rails_helper'

feature 'Queue Index' do
  let(:ee) { FactoryGirl.create(:admin, name: 'Joe Shoe') }

  scenario "I can add a student to the Queue" do
    student = FactoryGirl.create(:user)
    question = FactoryGirl.
      create(:question,
        user: student,
        title: 'What is the meaning to life?'
        )

    sign_in_as ee
    visit questions_path
    click_on question.title
    click_on "Let's Talk!"

    visit questions_path(query: 'queued')
    expect(page).to have_content(student.name)
    expect(page).to have_content('What is the meaning to life?')
  end

  scenario "I can own a Question Queue by saying I'm on it" do
    student = FactoryGirl.create(:user)
    qq = FactoryGirl.create(:question_queue)
    FactoryGirl.
      create(:question,
        question_queue: qq,
        user: student,
        title: 'What is the meaning to life?'
        )

    sign_in_as ee
    visit questions_path(query: 'queued')
    click_on "I'm on it!"

    expect(page).to have_content(ee.name)
    expect(page).to have_content("We Solved It!")

    visit questions_path
    expect(page).to have_content("Assigned to Joe Shoe")
  end

  scenario %"I can complete a question
    I've finished talking to a Student about" do
    student = FactoryGirl.create(:user)
    qq = FactoryGirl.create(:question_queue, status: 'in-progress', user: ee)
    question = FactoryGirl.
      create(:question,
        question_queue: qq,
        user: student,
        title: 'What is the meaning to life?'
        )

    sign_in_as ee
    visit questions_path(query: 'queued')
    click_on "We Solved It!"

    expect(page).not_to have_content("We Solved It!")
    expect(page).not_to have_content(question.title)

    visit questions_path
    expect(page).to have_content("Done")
  end

  scenario %"I can tag a question as a No Show to
    move it to the bottom of the queue" do
    student = FactoryGirl.create(:user)
    question = FactoryGirl.
      create(:question,
        user: student,
        title: 'What is the meaning to life?'
        )
    question.queue

    FactoryGirl.create(:user)
    question2 = FactoryGirl.
      create(:question,
        user: student,
        title: 'Why does my postgresql not work????'
        )
    question2.queue

    sign_in_as ee
    visit questions_path(query: 'queued')

    expect(page.body.index('What is the meaning to life')).
      to be < page.body.index('Why does my postgresql not work')
    within("#queue_#{question.question_queue.id}") do
      click_on "No Show"
    end
    expect(page.body.index('Why does my postgresql not work')).
      to be < page.body.index('What is the meaning to life')

    visit questions_path
    expect(page).to have_content("Queued")
  end

  scenario "3 no shows marks a question as done" do
    student = FactoryGirl.create(:user)
    qq = FactoryGirl.create(:question_queue)
    FactoryGirl.
      create(:question,
        question_queue: qq,
        user: student,
        title: 'What is the meaning to life?'
        )

    sign_in_as ee
    visit questions_path(query: 'queued')
    click_on "No Show"
    click_on "No Show"
    click_on "No Show"
    expect(page).to_not have_content('What is the meaning to life?')
  end
end
