require "rails_helper"

feature "view users" do
  context "as a user" do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      sign_in_as(user)
    end

    scenario "view auth settings on own page" do
      visit root_path

      click_link "Signed in as #{user.username}"
      expect(page).to have_selector("input[value='#{user.token}']")
    end

    scenario "view comments on submissions on own page" do
      visit root_path

      click_link "Signed in as #{user.username}"
      expect(page).to have_content("Number Of Comments")
    end

    scenario "cannot view auth token for other user" do
      other_user = FactoryGirl.create(:user)

      visit user_path(other_user)
      expect(page).to_not have_content(other_user.token)
    end

    scenario "view teams they belong to" do
      team_memberships = FactoryGirl.
        create_list(:team_membership, 3, user: user)

      visit user_path(user)

      team_memberships.each do |membership|
        team = membership.team

        expect(page).to have_link(team.name, href: team_path(team))
      end
    end
  end

  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    before :each do
      sign_in_as(admin)
    end

    scenario "view list of registered users" do
      users = FactoryGirl.create_list(:user, 3)

      visit users_path

      users.each do |user|
        expect(page).to have_link(user.username, user_path(user))
      end
    end

    scenario "view submissions for a single user" do
      user = FactoryGirl.create(:user)
      submissions = FactoryGirl.create_list(:submission, 2, user: user)

      visit user_path(user)

      submissions.each do |submission|
        expect(page).to have_link_href(submission_path(submission))
      end
    end

    scenario "cannot view auth tokens for other user" do
      other_user = FactoryGirl.create(:user)

      visit user_path(other_user)
      expect(page).to_not have_content(other_user.token)
    end
  end
end
