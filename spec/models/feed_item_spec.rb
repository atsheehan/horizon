require 'rails_helper'

RSpec.describe FeedItem, :type => :model do
  it { should belong_to :subject }
  it { should belong_to :recipient }
  it { should belong_to :actor }

  it { should have_valid(:subject).when(Comment.new) }
  it { should have_valid(:subject).when(Assignment.new) }
  it { should have_valid(:subject).when(Announcement.new) }
  it { should_not have_valid(:subject).when(nil) }

  it { should have_valid(:recipient).when(User.new) }
  it { should_not have_valid(:recipient).when(nil) }

  it { should have_valid(:verb).when('created') }
  it { should_not have_valid(:verb).when(nil, '') }
end
