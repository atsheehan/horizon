require "rails_helper"

describe Submission do
  let(:submission) { FactoryGirl.create(:submission) }

  describe "#body=" do
    it "stores the contents as a single file in an archive" do
      submission = FactoryGirl.build(:submission)
      submission.body = "2 + 2 == 5"
      submission.save!

      contents = read_file_from_gzipped_archive(
        submission.archive.path, "file001")
      expect(contents).to eq("2 + 2 == 5")
    end
  end

  describe "comments" do
    let(:source_file) do
      FactoryGirl.create(:source_file, submission: submission)
    end

    let!(:general_comment) do
      FactoryGirl.create(:comment, submission: submission, line_number: nil)
    end

    let!(:inline_comment) do
      FactoryGirl.create(:comment,
        submission: submission,
        line_number: 1,
        source_file: source_file)
    end

    describe "#inline_comments" do
      it "selects comments with line numbers" do
        expect(submission.inline_comments).to include(inline_comment)
        expect(submission.inline_comments).to_not include(general_comment)
      end
    end

    describe "#general_comments" do
      it "selects comments not belonging to source files" do
        expect(submission.general_comments).to include(general_comment)
        expect(submission.general_comments).to_not include(inline_comment)
      end
    end
  end

  describe "#comments_count" do
    it "should be zero, initially" do
      expect(submission.comments_count).to eq(0)
    end

    it "should equal the number of comments" do
      FactoryGirl.create_list(:comment, 5, submission: submission)
      submission.reload
      expect(submission.comments_count).to eq(5)
    end
  end
end
