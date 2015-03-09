require "rails_helper"

feature "filter lessons" do
  let!(:article) { FactoryGirl.create(:article) }
  let!(:challenge) { FactoryGirl.create(:challenge) }
  let!(:exercise) { FactoryGirl.create(:lesson, type: "exercise") }
  let!(:tutorial) { FactoryGirl.create(:lesson, type: "tutorial") }

  scenario "order lessons by most recently created" do
    oldest = FactoryGirl.create(:lesson)
    newest = FactoryGirl.create(:lesson)

    visit lessons_path
    click_link "Most Recent"

    expect(page).to order_text(newest.title, oldest.title)
  end

  scenario "changing order does not change filter" do
    visit lessons_path
    click_link "Articles"
    click_link "Most Recent"

    expect(page).to have_content(article.title)
    expect(page).to have_no_content(challenge.title)
    expect(page).to have_no_content(exercise.title)
    expect(page).to have_no_content(tutorial.title)
  end

  scenario "changing filter does not change order" do
    oldest = FactoryGirl.create(:article)
    newest = FactoryGirl.create(:article)

    visit lessons_path
    click_link "Most Recent"
    click_link "Articles"

    expect(page).to have_no_content(challenge.title)
    expect(page).to order_text(newest.title, oldest.title)
  end
end
