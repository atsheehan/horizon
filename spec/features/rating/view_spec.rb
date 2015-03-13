require "rails_helper"

feature "view ratings" do

  scenario "view list of lesson ratings" do
    sign_in_as(FactoryGirl.create(:admin))

    lesson = FactoryGirl.create(:lesson)
    rating = FactoryGirl.create(:rating, lesson: lesson)

    visit ratings_path

    expect(page).to have_content(lesson.title)
    expect(page).to have_content(rating.clarity)
    expect(page).to have_content(rating.helpfulness)
    expect(page).to have_content(rating.comment)
  end
end
