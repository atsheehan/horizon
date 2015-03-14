require "rails_helper"

describe Comment do
  let(:source_file) { FactoryGirl.create(:source_file) }

  it { should belong_to :user }
  it { should belong_to :submission }
  it { should belong_to :source_file }

  it { should have_many(:feed_items).dependent(:destroy) }


  describe "validations" do
    it "requires line number if source file set" do
      comment = FactoryGirl.build(:comment)

      comment.source_file = source_file
      comment.line_number = nil
      expect(comment.valid?).to eq(false)

      comment.line_number = 42
      expect(comment.valid?).to eq(true)

      comment.source_file = nil
      expect(comment.valid?).to eq(false)
    end

    it "allows nil line number if no source file" do
      comment = FactoryGirl.build(:comment)
      comment.source_file = nil
      comment.line_number = nil

      expect(comment.valid?).to eq(true)
    end

    it 'creates a feed item' do
      comment = FactoryGirl.create(:comment)
      feed_item = comment.feed_items.first
      expect(feed_item).to_not be_nil
      expect(feed_item.actor).to eq(comment.user)
      expect(feed_item.recipient).to eq(comment.submission.user)
      expect(feed_item.verb).to eq('create')
    end
  end
end
