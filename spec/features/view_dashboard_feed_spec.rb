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
      sign_in_as user
      comment = FactoryGirl.create(:comment, submission: submission)
      visit root_path

      expect(page).to have_content(comment.user.username)
      expect(page).to have_content(comment.body)
    end

    scenario 'sees feed for assignment release' do
      team = FactoryGirl.create(:team)
      student = FactoryGirl.create(:user)
      FactoryGirl.create(:team_membership, user: student, team: team)
      assignment = FactoryGirl.create(:assignment, team: team)

      sign_in_as(student)
      visit root_path

      expect(page).to have_content(assignment.lesson.title)
    end

    scenario 'sees feed for announcements' do
      team = FactoryGirl.create(:team)
      student = FactoryGirl.create(:user)
      FactoryGirl.create(:team_membership, user: student, team: team)
      FactoryGirl.create(:announcement, team: team, title: 'New announcement released!')

      sign_in_as student

      visit root_path
      within '.feed-items' do
        expect(page).to have_content('New announcement released!')
      end
    end
  end

  context 'as unauthenticated user' do
    scenario 'feed items are not displayed' do
      FactoryGirl.create(:announcement, title: 'New announcement released!')

      visit root_path

      expect(page).to_not have_content('New announcement released!')
      expect(page).to_not have_selector('.feed-items')
    end
  end
end
