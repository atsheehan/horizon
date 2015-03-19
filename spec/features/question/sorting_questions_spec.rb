require "rails_helper"

feature "sort questions" do
  scenario "filter by category shows only relevant questions" do
    question = FactoryGirl.create(:question)
    visible_question = FactoryGirl.create(:code_syntax_question)

    visit questions_path
    click_link "Code syntax"
    expect(page).to have_content(visible_question.title)
    expect(page).to have_no_content(question.title)
  end

  scenario "filter by category sorts lessons with newest first" do
    first_question = FactoryGirl.create(:code_syntax_question)
    second_question = FactoryGirl.create(:code_syntax_question)

    visit questions_path
    click_link "Code syntax"

    expect(page).to order_text(second_question.title, first_question.title)
  end
end
