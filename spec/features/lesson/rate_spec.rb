require "rails_helper"

feature "rate lesson" do
  let(:lesson) { FactoryGirl.create(:lesson) }

  context "as a member" do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      sign_in_as(user)
    end

    scenario "rate new lesson" do
      visit lesson_path(lesson)

      within(:css, "#helpfulness") { choose("4") }
      within(:css, "#clarity") { choose("2") }
      fill_in "Additional comments (optional)", with: "So-so."

      click_button "Rate Lesson"

      expect(page).to have_content("Rating saved.")
      expect(lesson.ratings.count).to eq(1)

      rating = lesson.ratings.first
      expect(rating.comment).to eq("So-so.")
      expect(rating.helpfulness).to eq(4)
      expect(rating.clarity).to eq(2)
      expect(rating.user).to eq(user)
    end

    scenario "update existing rating" do
      FactoryGirl.create(
        :rating,
        lesson: lesson,
        user: user,
        helpfulness: 3,
        clarity: 1,
        comment: "So-so."
        )

      visit lesson_path(lesson)
      expect(page).to have_content("So-so.")

      fill_in "Additional comments (optional)", with: "Much better."
      within(:css, "#clarity") { choose("5") }
      click_button "Rate Lesson"

      expect(page).to have_content("Rating updated.")
      expect(lesson.ratings.count).to eq(1)

      rating = lesson.ratings.first
      expect(rating.comment).to eq("Much better.")
      expect(rating.clarity).to eq(5)
      expect(rating.helpfulness).to eq(3)
    end

    scenario "fail to update rating" do
      FactoryGirl.create(
        :rating,
        lesson: lesson,
        user: user,
        comment: "So-so."
        )

      visit lesson_path(lesson)
      long_comment = "a" * 10_000

      fill_in "Additional comments (optional)", with: long_comment
      click_button "Rate Lesson"

      expect(page).to have_content("Rating could not be updated.")
      expect(lesson.ratings.first.comment).to eq("So-so.")
    end

    scenario "fail to create new rating" do
      visit lesson_path(lesson)

      click_button "Rate Lesson"

      expect(page).to have_content("Rating could not be saved.")
      expect(lesson.ratings.count).to eq(0)
    end
  end

  context "as a guest" do
    scenario "the rating form is hidden" do
      visit lesson_path(lesson)
      expect(page).to_not have_content("Rate this lesson")
    end
  end
end
