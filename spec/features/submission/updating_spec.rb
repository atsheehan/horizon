require "rails_helper"

feature "update submission" do
  context "as a user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:submission) { FactoryGirl.create(:submission_with_file, user: user) }

    before :each do
      sign_in_as(user)
    end

    scenario "make submission public" do
      submission = FactoryGirl.create(:submission, user: user)
      visit submission_path(submission)

      click_button "Make Public"

      expect(page).to have_content("Submission updated.")
      within("#public") do
        expect(page).to have_content("true")
      end
    end

    scenario "hide public submission" do
      submission = FactoryGirl.create(:submission, user: user, public: true)
      visit submission_path(submission)

      click_button "Make Private"

      expect(page).to have_content("Submission updated.")
      within("#public") do
        expect(page).to have_content("false")
      end
    end

    scenario "hide button for other user submissions" do
      lesson = FactoryGirl.create(:lesson)
      FactoryGirl.create(:submission, lesson: lesson, user: user)
      submission = FactoryGirl.create(:submission, lesson: lesson, public: true)

      visit submission_path(submission)
      expect(page).to_not have_selector(:link_or_button, "Make Private")
    end
  end

  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    before :each do
      sign_in_as(admin)
    end

    scenario "mark submission as featured" do
      submission = FactoryGirl.create(:submission, featured: false)

      visit submission_path(submission)

      click_button "Make Featured"

      within("#featured") do
        expect(page).to have_content("true")
      end
    end

    scenario "remove featured from submission" do
      submission = FactoryGirl.create(:submission, featured: true)

      visit submission_path(submission)

      click_button "Remove Featured"

      within("#featured") do
        expect(page).to have_content("false")
      end
    end
  end
end
