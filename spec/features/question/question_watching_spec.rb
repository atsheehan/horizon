require 'rails_helper'

feature 'question watching' do
  context 'as an authorized user' do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      sign_in_as user
    end

    scenario 'creating question automatically adds it to my watch list' do
      visit new_question_path

      fill_in 'Title', with: 'What is the meaning of life? Is it 42?'
      fill_in 'Body', with: "I don't know what to spend my life doing. Someone tell me!"
      click_on 'Ask Question'

      visit questions_path
      expect(page).to have_content("Watching")
    end

    scenario 'I can watch other peoples questions' do
      watch_question

      expect(page).to have_content('Watching')
      expect(page).to have_content('Now watching question.')
    end

    scenario 'I can unwatch other peoples questions' do
      watch_question

      click_on 'Stop Watching'
      expect(page).to have_content('Watch Question')
      expect(page).to have_content('Stopped watching question.')
    end

    scenario 'I watch a question when answering on it' do
      question = FactoryGirl.create(:question)
      visit question_path(question)

      fill_in "Answer", with: "this is the answer to the question!"
      click_on "Submit Answer"

      visit questions_path
      expect(page).to have_content("Stop Watching")
    end
  end

  context 'as a visitor' do
    scenario 'I am prompted to sign in when trying to watch question' do
      watch_question
      expect(page).to have_content('You need to sign in before continuing.')
    end
  end
end

def watch_question
  FactoryGirl.create(:question)
  visit questions_path
  click_on 'Watch Question'
end
