require 'rails_helper'

feature 'question comments' do

  context 'as an authorized user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:question) { FactoryGirl.create(:question) }

    scenario 'I can create a comment on a question' do
      sign_in_as user
      visit question_path(question)

      create_question_comment('Please provide more details')
      expect(page).to have_content('Please provide more details')
    end

    scenario 'I can delete a comment I own' do
      sign_in_as user
      visit question_path(question)

      create_question_comment('Please provide more details')
      find('a.delete-question-comment').click

      expect(page).to_not have_content('Please provide more details')
    end
  end

  context 'as a visitor' do
    let(:question) { FactoryGirl.create(:question) }

    scenario 'I cannot create a comment for a question' do
      visit question_path(question)

      create_question_comment('Please provide more details')

      expect(page).to_not have_content('Please provide more details')
      expect(page).to have_content('You need to sign in before continuing.')
    end
  end
end

def create_question_comment(body)
  find('.add-question-comment a').click

  fill_in 'question_comment_body', with: body
  click_on 'create-question-comment'
end
