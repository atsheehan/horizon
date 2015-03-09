require "rails_helper"

RSpec.describe Lesson, type: :model do

  it { should have_many(:lesson_tags) }
  it { should have_many(:tags) }

  describe ".visible_for" do
    let(:user) { FactoryGirl.create(:user) }

    context "lesson is publicaly visible" do
      it "returns publicaly visible lesson" do
        lesson = FactoryGirl.create(:lesson)
        FactoryGirl.create(:lesson, visibility: 'assign')
        expect(Lesson.visible_for(user)).to match_array [lesson]
      end
    end

    context "lesson is assigned to a user" do
      it "returns lesson assigned to that user" do
        assignment = FactoryGirl.create(:assignment)
        FactoryGirl.create(:team_membership, team: assignment.team, user: user)
        FactoryGirl.create(:lesson, visibility: 'assign')
        expect(Lesson.visible_for(user)).to match_array [assignment.lesson]
      end
    end

    context "lesson query has a joined table" do
      it "returns visible lessons and lessons assigned to that user" do
        assignment = FactoryGirl.create(:assignment)
        FactoryGirl.create(:team_membership, team: assignment.team, user: user)
        lesson1 = FactoryGirl.create(:lesson, visibility: 'assign')
        lesson2 = FactoryGirl.create(:lesson)
        assignment.lesson.generate_tags(["jquery"])
        lesson1.generate_tags(["jquery"])
        lesson2.generate_tags(["jquery"])
        expect(Lesson.tagged("jquery").visible_for(user)).to match_array [
          assignment.lesson, lesson2
        ]
      end
    end
  end

  describe ".search" do
    let!(:foo) do
      FactoryGirl.
        create(:lesson,
          title: "Blah",
          body: "i like pizza",
          description: "bloop"
          )
    end

    let!(:bar) do
      FactoryGirl.
        create(:lesson, title: "Shazbot", body: "Ruby sure is fun.")
    end

    let!(:baz) do
      FactoryGirl.
        create(:lesson,
          title: "Mr. Grumblecat", body: "Ruby gems and fiddle sticks.")
    end

    it "searches by title" do
      results = Lesson.search("blah")

      expect(results).to include(foo)
      expect(results).to_not include(bar)
      expect(results).to_not include(baz)
    end

    it "searches by body" do
      results = Lesson.search("ruby")

      expect(results).to_not include(foo)
      expect(results).to include(bar)
      expect(results).to include(baz)
    end

    it "searches by description" do
      results = Lesson.search("bloop")

      expect(results).to include(foo)
      expect(results).to_not include(bar)
      expect(results).to_not include(baz)
    end

    it "ignores order of query terms" do
      results = Lesson.search("stick fiddle")

      expect(results).to_not include(foo)
      expect(results).to_not include(bar)
      expect(results).to include(baz)
    end
  end

  let(:sample_lessons_dir) { Rails.root.join("spec/data/sample_lessons") }

  describe ".import_all!" do
    it "imports lessons from a source directory" do
      Lesson.import_all!(sample_lessons_dir)

      lesson = Lesson.find_by!(slug: "expressions")
      expect(lesson.title).to eq("Expressions")
      expect(lesson.type).to eq("article")
      expect(lesson.description).to eq("bloop.")
      expect(lesson.visibility).to eq("assign")
      expect(lesson.body).to eq("beep boop i'm an expression\n")
      expect(lesson.tags.pluck(:name)).to include("expressions")
    end

    it "updates an existing lesson" do
      FactoryGirl.create(:lesson, slug: "expressions", body: "blah")

      Lesson.import_all!(sample_lessons_dir)

      lesson = Lesson.find_by!(slug: "expressions")
      expect(lesson.body).to eq("beep boop i'm an expression\n")
    end

    it "packages an archive for a challenge" do
      Lesson.import_all!(sample_lessons_dir)

      lesson = Lesson.find_by!(slug: "rock-paper-scissors")
      expect(lesson.type).to eq("challenge")
      expect(lesson.archive.url).to_not eq(nil)
    end

    it "packages an archive for an exercise" do
      Lesson.import_all!(sample_lessons_dir)

      lesson = Lesson.find_by!(slug: "max-number")
      expect(lesson.type).to eq("exercise")
      expect(lesson.archive.url).to_not eq(nil)
    end
  end

  describe ".generate_tags" do
    it "creates new associated tag objects from an array" do
      lesson = FactoryGirl.create(:lesson)
      tags = ["javascript", "json", "ajax"]

      lesson.generate_tags(tags)
      expect(lesson.tags.pluck(:name)).to include("javascript")
      expect(lesson.tags.pluck(:name)).to include("json")
      expect(lesson.tags.pluck(:name)).to include("ajax")
    end

    it "creates associations to existing tags if possible" do
      old_lesson = FactoryGirl.create(:lesson)
      old_lesson.generate_tags(["jquery"])

      lesson = FactoryGirl.create(:lesson)
      lesson.generate_tags(["jquery"])

      expect(lesson.tags).to eq(old_lesson.tags)
    end

    it "does not create duplicate lesson_tags if run a second time" do
      lesson = FactoryGirl.create(:lesson)
      lesson.generate_tags(["jquery"])
      lesson.generate_tags(["jquery"])

      expect(lesson.lesson_tags.length).to eq(1)
    end

    it "removes old existing tags if they no longer apply" do
      lesson = FactoryGirl.create(:lesson)
      lesson.generate_tags(["jquery", "data-types"])
      lesson.generate_tags(["jquery"])

      expect(lesson.tags.pluck(:name)).to include("jquery")
      expect(lesson.tags.pluck(:name)).to_not include("data-types")
    end
  end

  describe "filtering" do
    it "filters by visibility for user" do
      user = FactoryGirl.create(:user)
      public_lesson = FactoryGirl.create(:lesson)
      private_lesson = FactoryGirl.create(:lesson, visibility: "assign")

      expect(Lesson.visible_for(user)).to include(public_lesson)
      expect(Lesson.visible_for(user)).to_not include(private_lesson)
    end

    it "filters by type" do
      article = FactoryGirl.create(:article)
      challenge = FactoryGirl.create(:challenge)

      expect(Lesson.type("article")).to include(article)
      expect(Lesson.type("article")).to_not include(challenge)
    end

    it "filters by tag" do
      lesson = FactoryGirl.create(:lesson)
      ajax_lesson = FactoryGirl.create(:lesson)
      ajax_lesson.generate_tags(["ajax"])

      expect(Lesson.tagged("ajax")).to include(ajax_lesson)
      expect(Lesson.tagged("ajax")).to_not include(lesson)
    end
  end
end
