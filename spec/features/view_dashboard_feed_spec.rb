require 'rails_helper'

feature "view dashboard feed", %Q{
  As an authenticated user
  I want to see an activity feed
  So that I can be informed of Launch Academy happenings
} do

  context 'signed in user' do
    let(:user) { FactoryGirl.create(:user) }
    let(:submission) { FactoryGirl.create(:submission, user: user) }

    scenario 'sees feed for submission comment' do
      comment = FactoryGirl.create(:comment, submission: submission)
      sign_in_as(user)
      visit root_path

      expect(page).to have_content(comment.user.username)
      expect(page).to have_content(comment.body)
    end

    scenario 'sees feed for assignment release' do
      team = FactoryGirl.create(:team)
      student = FactoryGirl.create(:user)
      ee = FactoryGirl.create(:user, role: "admin")
      FactoryGirl.create(:team_membership, user: student, team: team)
      assignment = FactoryGirl.create(:assignment, team: team)

      sign_in_as(student)
      visit root_path

      expect(page).to have_content(assignment.lesson.title)
    end

  end
  scenario 'unauthenticated'
end
