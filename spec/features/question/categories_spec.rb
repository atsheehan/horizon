require 'rails_helper'

feature 'Question Categories' do
  scenario 'Are listed on the question page' do
    FactoryGirl.create(:question, title: 'Code Syntax Question Title', category: 'code syntax')
    FactoryGirl.create(:question, title: 'Code Reivew Question Title', category: 'code review')
    FactoryGirl.create(:question, title: 'Problem Breakdown Question Title', category: 'problem breakdown')
    FactoryGirl.create(:question, title: 'Best Practices Question Title', category: 'best practices')
    FactoryGirl.create(:question, title: 'Other Question Title', category: 'other')

    visit questions_path
    within '.category-filters' do
      expect(page).to have_content 'Code Syntax'
      expect(page).to have_content 'Code Review'
      expect(page).to have_content 'Problem Breakdown'
      expect(page).to have_content 'Best Practices'
      expect(page).to have_content 'Other'
    end

    within '.category-filters' do
      click_on 'Code Syntax'
    end

    within '.questions' do
      expect(page).to have_content 'Code Syntax Question Title'
      expect(page).not_to have_content 'Code Review Question Title'
      expect(page).not_to have_content 'Problem Breakdown Question Title'
      expect(page).not_to have_content 'Best Practices Question Title'
      expect(page).not_to have_content 'Other Question Title'
    end
  end

  scenario 'are selectable when adding a question' do
    user = FactoryGirl.create(:user)
    sign_in_as user
    visit new_question_path

    fill_in 'Title', with: 'What is the meaning of life? Is it 42?'
    fill_in 'Body', with: "I don't know what to spend my life doing. Someone tell me!"
    select 'Code review', from: 'question_category'
    click_on 'Ask Question'

    visit questions_path
    expect(page).to have_content("Watching")

    within '.questions' do
      expect(page).to have_content("Code review")
    end
  end
end
