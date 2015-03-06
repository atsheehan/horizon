require "rails_helper"

feature "view dashboard" do
  context "as a user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:team) { FactoryGirl.create(:team) }

    before :each do
      FactoryGirl.create(:team_membership, user: user, team: team)
      sign_in_as(user)
    end

    scenario "show upcoming assignments" do
      first_assignment = FactoryGirl.create(:assignment,
        due_on: 1.day.from_now,
        team: team)

      second_assignment = FactoryGirl.create(:assignment,
        due_on: 2.days.from_now,
        team: team)

      visit dashboard_path

      expect(page).to order_text(
        first_assignment.lesson.title, second_assignment.lesson.title)

      expect(page).to have_content(format_datetime(first_assignment.due_on))
    end
  end
end
