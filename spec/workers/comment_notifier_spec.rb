require "rails_helper"

describe CommentNotifier do
  let(:notifier) { CommentNotifier.new }

  describe "#perform" do
    it "notifies the owner of the submission" do
      comment = FactoryGirl.create(:comment)
      notifier.perform(comment.id)
      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "batches pending emails for a submission" do
      submission = FactoryGirl.create(:submission)
      comments = FactoryGirl.create_list(:comment, 3,
        submission: submission,
        delivered: false)

      expect(Comment.pending.count).to eq(3)

      # Schedule the job once per comment but it should only send an e-mail the
      # first time.
      comments.each do |comment|
        notifier.perform(comment.id)
      end

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(Comment.pending.count).to eq(0)
    end

    it "sends different emails for different submissions" do
      user = FactoryGirl.create(:user)
      submission_a = FactoryGirl.create(:submission, user: user)
      submission_b = FactoryGirl.create(:submission, user: user)
      comment_a = FactoryGirl.
        create(:comment, submission: submission_a, delivered: false)
      comment_b = FactoryGirl.
        create(:comment, submission: submission_b, delivered: false)

      notifier.perform(comment_a.id)
      notifier.perform(comment_b.id)

      expect(ActionMailer::Base.deliveries.count).to eq(2)
    end

    it "doesn't send duplicate e-mails" do
      comment = FactoryGirl.create(:comment)

      notifier.perform(comment.id)
      notifier.perform(comment.id)

      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it "doesn't email if commenter is the submitter" do
      submission = FactoryGirl.create(:submission)
      comment = FactoryGirl.create(:comment,
        user: submission.user,
        submission: submission)

      notifier.perform(comment.id)
      expect(ActionMailer::Base.deliveries.count).to eq(0)
    end
  end
end
