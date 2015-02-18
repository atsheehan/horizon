require "rails_helper"

feature "search" do
  scenario "search by keyword" do
    lesson = FactoryGirl.create(:lesson, title: "Blah", body: "foo")
    question = FactoryGirl.create(:question, title: "What is the meaning to life?", body: "code and someother stuff that fills up the body")
    FactoryGirl.create(:answer, question: question, body: "I don't think thats right... foo.")

    FactoryGirl.create(:lesson, title: "Bloop", body: "bar")
    FactoryGirl.create(:question, title: "Bloop is not the meaning", body: "bar and someother stuff that fills up the body")
    FactoryGirl.create(:answer, body: "bar is definitely right")

    visit root_path
    fill_in "query", with: "foo"
    click_button "Search"

    expect(page).to have_content("Found 2 result(s) for \"foo\".")
    expect(page).to have_link("Blah", href: lesson_path(lesson))
    expect(page).to have_link("What is the meaning to life?", href: question_path(question))
    expect(page).to_not have_content("Bloop")
  end

  scenario "no results found" do
    FactoryGirl.create(:challenge, title: "Blah", body: "foo")

    visit root_path
    fill_in "query", with: "baz"
    click_button "Search"

    expect(page).to have_content("No results found for \"baz\".")
    expect(page).to_not have_content("Blah")
  end
end
