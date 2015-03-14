require 'rails_helper'

feature 'answer comments' do

  context 'as an authorized user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:question) { FactoryGirl.create(:question) }
    let!(:answer) { FactoryGirl.create(:answer, question: question) }

    scenario 'I can create a comment on an answer' do
      sign_in_as user
      visit question_path(question)

      create_answer_comment('Wow this was a great answer!')

      expect(page).to have_content('Wow this was a great answer!')
    end

    scenario 'I can delete a comment I own' do
      sign_in_as user
      visit question_path(question)

      create_answer_comment('Wow this was a great answer!')
      find('a.delete-answer-comment').click

      expect(page).to_not have_content('Wow this was a great answer!')
    end
  end

  context 'as a visitor' do
    let(:question) { FactoryGirl.create(:question) }
    let!(:answer) { FactoryGirl.create(:answer, question: question) }

    scenario 'I cannot create a comment for an answer' do
      visit question_path(question)

      create_answer_comment('Wow this was a great answer!')

      expect(page).to_not have_content('Wow this was a great answer!')
      expect(page).to have_content('You need to sign in before continuing.')
    end
  end
end

def create_answer_comment(body)
  find('.add-answer-comment a').click

  fill_in 'answer_comment_body', with: body
  click_on 'create-answer-comment'
end
