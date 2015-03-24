FactoryGirl.define do
  factory :vote do
    user
  end

  factory :lesson do
    type "article"
    sequence(:title) { |n| "Article #{n}" }
    sequence(:slug) { |n| "article-#{n}" }
    description "Describes the article."
    body "# Article Foo\n\nThis is an article."
    visibility "public"

    factory :article do
      type "article"
    end

    factory :challenge do
      type "challenge"

      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/one_file.tar.gz"))
      end
    end
  end

  factory :tag do
    name "jquery"
  end

  factory :lesson_tag do
    lesson
    tag
  end

  factory :comment do
    user
    submission
    body "Needs more cow-bell."
  end

  factory :rating do
    user
    lesson

    clarity 2
    helpfulness 4
    comment "Not bad."
  end

  factory :submission do
    association :lesson, factory: :challenge
    user
    public false

    archive do
      Rack::Test::UploadedFile.new(Rails.root.join("spec/data/one_file.tar.gz"))
    end

    factory :submission_with_two_file_archive do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/two_files.tar.gz"))
      end
    end

    factory :submission_with_file do
      after(:create) do |submission|
        FactoryGirl.create(:source_file, submission: submission)
      end
    end

    factory :submission_with_nested_files do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/nested_files.tar.gz"))
      end
    end

    factory :submission_with_ignored_files do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/ignored_files.tar.gz"))
      end
    end

    factory :submission_with_large_file do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/large_file.tar.gz"))
      end
    end

    factory :submission_with_binary_file do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/binary_file.tar.gz"))
      end
    end

    factory :submission_with_gitignore do
      archive do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/data/has_gitignore.tar.gz"))
      end
    end
  end

  factory :source_file do
    submission
    filename "foo.rb"
    body "2 + 2 == 5\n"
  end

  factory :identity do
    association :user, factory: :user_without_identity

    provider 'github'
    sequence(:uid) { |n| n.to_s }


    factory :github_identity

    factory :launch_pass_identity do
      provider 'launch_pass'
      sequence(:uid) { |n| n.to_s }
    end
  end

  factory :user_without_identity, class: User do
    sequence(:username) { |n| "george_michael_#{n}" }
    sequence(:email) { |n| "gm#{n}@example.com" }
    first_name "George"
    sequence(:last_name) { |n| "Michael #{n}" }
    role "member"

    factory :user do
      factory :admin do
        role "admin"
      end

      factory :user_with_assignment_submission do
        after(:create) do |user|
          team_membership = create(:team_membership , user: user)
          assignment = create(:assignment, team: team_membership.team)
          create(:submission, lesson: assignment.lesson, user: user)
        end
      end

      ignore do
        calendar_args nil
      end

      factory :user_with_calendar do
        after(:create) do |user, evaluator|
          calendar = build(:calendar, evaluator.calendar_args)
          team = create(:team, calendar: calendar)
          create(:team_membership, team: team, user: user)
        end
      end

      factory :user_with_multiple_assignment_submissions do
        after(:create) do |user|
          team_membership = create(:team_membership , user: user)
          core = create(:assignment, team: team_membership.team)
          create(:assignment, required: false, team: team_membership.team)
          create(:submission, lesson: core.lesson, user: user)
        end
      end
    end
  end

  factory :team do
    sequence(:name) { |n| "Team #{n}" }
  end

  factory :team_membership do
    user
    team
  end

  factory :assignment do
    team
    lesson
    due_on { DateTime.now + 1.day }
    required true
  end

  factory :announcement do
    sequence(:title) { |n| "Announcement #{n}" }
    description "Here is a very nice description for a very nice announcement.
      The students shall cheer and rejoice when they see it."
    team
  end

  factory :calendar do
    sequence(:name) { |n| "Calendar #{n}" }
    sequence(:cid) { |n| "calendar-reference-email#{n}@gmail.com" }
  end

  factory :question do
    sequence(:title) { |n| "Question #{n}" }
    body "This is definitely a question."
    category "Other"
    user

    factory :code_syntax_question do
      category "Code syntax"
    end
  end

  factory :question_queue do
  end

  factory :answer do
    question
    user
    sequence(:body) { |n| "This is definitely the right answer #{n}." }
  end
end
