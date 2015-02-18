require "rails_helper"

feature "lesson visibility" do
  let!(:public_lesson) { FactoryGirl.create(:lesson, visibility: "public") }
  let!(:private_lesson) { FactoryGirl.create(:lesson, visibility: "assign") }

  context "as a guest" do
    scenario "view only public lessons" do
      visit lessons_path

      expect(page).to have_content(public_lesson.title)
      expect(page).to_not have_content(private_lesson.title)
    end
  end

  context "as a team member" do
    let(:team_member) { FactoryGirl.create(:team_membership) }

    before :each do
      sign_in_as(team_member.user)
    end

    scenario "hide non-public, un-assigned lessons" do
      visit lessons_path

      expect(page).to have_content(public_lesson.title)
      expect(page).to_not have_content(private_lesson.title)
    end

    scenario "view assigned lessons" do
      FactoryGirl.create(:assignment,
        team: team_member.team,
        lesson: private_lesson)

      visit lessons_path

      expect(page).to have_content(public_lesson.title)
      expect(page).to have_content(private_lesson.title)
    end
  end
end
