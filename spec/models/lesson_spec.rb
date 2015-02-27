require "rails_helper"

RSpec.describe Lesson, type: :model do

  it { should have_many(:lesson_tags) }
  it { should have_many(:tags) }

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
  end
end
