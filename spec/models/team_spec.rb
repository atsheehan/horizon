require "rails_helper"

RSpec.describe Team, type: :model do
  it { should have_many(:team_memberships) }
  it { should have_many(:users) }
  it { should have_many(:assignments) }
  it { should have_many(:announcements) }
  it { should belong_to(:calendar) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
