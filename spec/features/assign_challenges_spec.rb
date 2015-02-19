require "rails_helper"

feature "assign challenges" do
  let(:team) { FactoryGirl.create(:team) }

  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    before :each do
      sign_in_as(admin)
    end

    scenario "assign challenge to team" do
      challenge = FactoryGirl.create(:challenge, title: "FizzBuzz")

      visit team_assignments_path(team)

      select "FizzBuzz", from: "Challenge"
      fill_in "Due Date", with: "2014-11-14T11:00:00-0500"
      check "Required"

      click_button "Add Assignment"

      expect(Assignment.count).to eq(1)

      assignment = Assignment.first
      expect(assignment.team).to eq(team)
      expect(assignment.lesson).to eq(challenge)
      expect(assignment.due_on).to eq("2014-11-14T11:00:00-0500")
      expect(assignment.required).to eq(true)

      expect(page).to have_content("Added assignment for FizzBuzz.")
    end

    scenario "re-render form when missing info" do

      visit team_assignments_path(team)

      click_button "Add Assignment"

      expect(Assignment.count).to eq(0)
      expect(page).to have_content("Failed to add assignment.")
    end
  end
end
