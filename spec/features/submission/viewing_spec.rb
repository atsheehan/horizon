require "rails_helper"

feature "view submissions" do
  let(:lesson) { FactoryGirl.create(:lesson, type: "challenge") }

  context "as a user" do
    let(:user) { FactoryGirl.create(:user) }

    before :each do
      sign_in_as(user)
    end

    scenario "include link to view public submissions" do
      visit lesson_path(lesson)
      expect(page).
        to have_link("Submissions", href: lesson_submissions_path(lesson))
    end

    scenario "see my submissions for a lesson" do
      my_submissions = FactoryGirl.
        create_list(:submission, 2, lesson: lesson, user: user)
      other_submissions = FactoryGirl.
        create_list(:submission, 2, lesson: lesson)

      visit lesson_submissions_path(lesson)

      my_submissions.each do |submission|
        expect(page).to have_link_href(submission_path(submission))
      end

      other_submissions.each do |submission|
        expect(page).to_not have_link_href(submission_path(submission))
      end
    end

    scenario "see public submissions from other users" do
      my_submission = FactoryGirl.
        create(:submission, lesson: lesson, user: user)
      submissions = FactoryGirl.
        create_list(:submission, 3, lesson: lesson, public: true)

      visit lesson_submissions_path(lesson)

      submissions.each do |submission|
        expect(page).to have_content(submission.user.username)
        expect(page).to have_link_href(submission_path(submission))
      end

      submission = submissions[0]

      visit submission_path(submission)
      expect(page).to have_content("Submission for #{submission.lesson.title}")
      expect(page).to have_content(submission.user.username)
    end

    scenario "hide other public submissions if haven't submitted once" do
      submission = FactoryGirl.
        create(:submission, lesson: lesson, public: true)

      visit lesson_submissions_path(lesson)

      expect(page).to_not have_content(submission.user.username)
      expect(page).to_not have_link_href(submission_path(submission))

      expect(page).to have_content(
        "Other submissions hidden until you've submitted yours.")
    end

    scenario "view submission with multiple files" do
      submission = FactoryGirl.create(:submission, user: user)
      FactoryGirl.create(
        :source_file,
        submission: submission,
        filename: "bar.rb",
        body: "b = 2"
      )
      FactoryGirl.create(
        :source_file,
        submission: submission,
        filename: "foo.rb",
        body: "a = 1"
        )

      visit submission_path(submission)

      expect(page).to have_content("foo.rb")
      expect(page).to have_content("a = 1")
      expect(page).to have_content("bar.rb")
      expect(page).to have_content("b = 2")

      expect(page).to order_text("bar.rb", "foo.rb")
    end
  end

  context "as an admin" do
    let(:admin) { FactoryGirl.create(:admin) }

    before :each do
      sign_in_as(admin)
    end

    scenario "see all of the submissions for a lesson" do
      submissions = FactoryGirl.
        create_list(:submission, 3, lesson: lesson)

      visit lesson_submissions_path(lesson)

      submissions.each do |submission|
        expect(page).to have_link_href(submission_path(submission))
      end
    end

    scenario "view submission from student" do
      submission = FactoryGirl.create(
        :submission_with_file,
        lesson: lesson
        )

      visit submission_path(submission)

      expect(page).to have_content("Submission for #{lesson.title}")
      expect(page).to have_content(submission.user.username)
    end

    context "for a team assignment" do
      scenario "check team member submission" do
        team_member = FactoryGirl.create(:team_membership)

        submission = FactoryGirl.create(:submission,
          user: team_member.user,
          lesson: lesson,
          created_at: 2.days.ago)

        assignment = FactoryGirl.create(:assignment,
          team: team_member.team,
          lesson: lesson,
          due_on: 1.day.ago)

        visit assignment_path(assignment)

        expect(page).
          to have_link(team_member.user.username,
            href: submission_path(submission)
            )
        expect(page).to have_content("On-Time")
      end

      scenario "late if missing submission" do
        team_member = FactoryGirl.create(:team_membership)
        assignment = FactoryGirl.create(:assignment,
          team: team_member.team,
          lesson: lesson,
          due_on: 1.day.ago)

        visit assignment_path(assignment)
        expect(page).to have_content(team_member.user.username)
        expect(page).to have_content("Late")
      end
    end
  end

  context "as a guest" do
    scenario "redirect to login" do
      visit lesson_submissions_path(lesson)

      expect(page).to have_content("You need to sign in before continuing.")
      expect(page).to_not have_content("Submissions for #{lesson.title}")
    end
  end
end
