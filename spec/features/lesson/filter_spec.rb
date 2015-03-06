require "rails_helper"

feature "filter lessons" do
  let!(:article) { FactoryGirl.create(:article) }
  let!(:challenge) { FactoryGirl.create(:challenge) }
  let!(:exercise) { FactoryGirl.create(:lesson, type: "exercise") }
  let!(:tutorial) { FactoryGirl.create(:lesson, type: "tutorial") }

  scenario "filter lessons to only view articles" do
    visit lessons_path
    click_link "Articles"

    expect(page).to have_link(article.title)
    expect(page).to have_no_link(challenge.title)
    expect(page).to have_no_link(exercise.title)
    expect(page).to have_no_link(tutorial.title)
  end

  scenario "filter lessons to only view challenges" do
    visit lessons_path
    click_link "Challenges"

    expect(page).to have_link(challenge.title)
    expect(page).to have_no_link(article.title)
    expect(page).to have_no_link(exercise.title)
    expect(page).to have_no_link(tutorial.title)
  end

  scenario "filter lessons to only view exercises" do
    visit lessons_path
    click_link "Exercises"

    expect(page).to have_link(exercise.title)
    expect(page).to have_no_link(article.title)
    expect(page).to have_no_link(challenge.title)
    expect(page).to have_no_link(tutorial.title)
  end

  scenario "filter lessons to only view tutorial" do
    visit lessons_path
    click_link "Tutorials"

    expect(page).to have_link(tutorial.title)
    expect(page).to have_no_link(article.title)
    expect(page).to have_no_link(exercise.title)
    expect(page).to have_no_link(challenge.title)
  end
end
