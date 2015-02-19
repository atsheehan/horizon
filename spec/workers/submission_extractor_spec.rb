require "rails_helper"

describe SubmissionExtractor do
  let(:extractor) { SubmissionExtractor.new }

  describe "#perform" do
    it "extracts a single source file" do
      submission = FactoryGirl.create(:submission)
      extractor.perform(submission.id)
      expect(submission.files.count).to eq(1)
    end

    it "does not create duplicate files when re-run" do
      submission = FactoryGirl.create(:submission)

      extractor.perform(submission.id)
      extractor.perform(submission.id)
      expect(submission.files.count).to eq(1)
    end

    it "extracts multiple source files" do
      submission = FactoryGirl.create(:submission_with_two_file_archive)
      extractor.perform(submission.id)
      expect(submission.files.count).to eq(2)
    end

    it "preserves directories" do
      submission = FactoryGirl.create(:submission_with_nested_files)

      extractor.perform(submission.id)
      expect(submission.files.count).to eq(2)

      filenames = submission.files.map { |f| f.filename }

      expect(filenames).to include("foo.rb")
      expect(filenames).to include("bar/baz/bat.rb")
    end

    it "ignores certain files" do
      submission = FactoryGirl.create(:submission_with_ignored_files)

      extractor.perform(submission.id)
      expect(submission.files.count).to eq(1)

      expect(submission.files[0].filename).to eq(".important")
    end

    it "uses a placeholder for large files" do
      submission = FactoryGirl.create(:submission_with_large_file)

      extractor.perform(submission.id)
      expect(submission.files.count).to eq(1)

      expect(submission.files[0].filename).to eq("large_file")
      expect(submission.files[0].body).
        to eq("File too large to display (50006 bytes)")
    end

    it "uses a placeholder for binary files" do
      submission = FactoryGirl.create(:submission_with_binary_file)

      extractor.perform(submission.id)
      expect(submission.files.count).to eq(1)

      expect(submission.files[0].filename).to eq("kitten.jpg")
      expect(submission.files[0].body).
        to eq("Binary file (14695 bytes)")
    end
  end
end
