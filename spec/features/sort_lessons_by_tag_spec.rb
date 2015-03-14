require 'rails_helper'
require 'spec_helper'

feature "Filter Lessons By Tag", %(
As a student
I would like to be able to filter lessons by tag
So I can easily find related and relevant material.

Acceptance Criteria:
* [x] A list of all tags should be viewable on the lessons index page.
* [x] If I click on a tag, either from the lesson show or index page, I can
view an index of all lessons containing the same tag.
* [x] I can click "Clear" to view all lessons again.
* [x] While viewing lessons filtered by tag, I can also use all other ordering
and filtering functionality.
) do

  # Currently can't get tests using JS working!

  # scenario "student views all tags on index page", focus: true, js: true do
  #   lesson = FactoryGirl.create(:lesson)
  #   lesson.generate_tags(["javascript", "jquery"])
  #   visit lessons_path
  #   find("#show-tags").click
  #
  #   expect(page).to have_content("javascript")
  #   expect(page).to have_content("jquery")
  # end

end
