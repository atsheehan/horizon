require 'rails_helper'

feature "View Lesson Tags", %(
  As a student
  I want to see what tags are assigned to a lesson
  So that I can quickly see what topics the lesson covers

  Acceptance Criteria:
  * [x] A tag contains lowercase letters and numbers. Words in multi-word tags
    are separated using dashes (e.g. "ruby-on-rails").
  * [x] A tag can be used by many lessons and a lesson can have many tags.
  * [x] Tags are imported during the "horizon:import_lessons" rake task.
  * [x] The importer can run repeatedly without creating duplicate tags.
  * [x] If an existing tag is removed from the metadata it is removed from the
    database during import.
  * [x] If a lesson does not have a list of tags in the metadata it is
    interpreted as no tags.
  * [x] The tags are viewable on the lesson show page.
) do

  scenario "student views lesson details and sees tags" do
    lesson = FactoryGirl.create(:lesson)
    lesson.generate_tags(["jquery", "data-types"])

    visit lesson_path(lesson)

    lesson.tags.each do |tag|
      expect(page).to have_content(tag.name)
    end
  end

end
