require 'rails_helper'

RSpec.describe Identity, :type => :model do
  it { should belong_to(:user) }

  it { should have_valid(:uid).when('341234', '134123521') }
  it { should_not have_valid(:uid).when(nil, '') }

  it { should have_valid(:provider).when('github', 'launch_pass') }
  it { should_not have_valid(:provider).when(nil, '', 'another provider') }

  it { should have_valid(:user).when(User.new) }
  it { should_not have_valid(:user).when(nil) }

  describe ".find_or_create_from_omniauth" do
    let(:uid) { "123456" }
    let(:provider) { "github" }

    let(:auth_hash) do
      {
        "provider" => provider,
        "uid" => uid,
        "info" => {
          "nickname" => "boblob",
          "email" => "bob@example.com",
          "name" => "Bob Loblaw"
        }
      }
    end

    it "creates a new user" do
      identity = self.described_class.find_or_create_from_omniauth(auth_hash)
      user = identity.user

      expect(identity.uid).to eq(uid)
      expect(identity.provider).to eq(provider)

      expect(user.email).to eq("bob@example.com")
      expect(user.username).to eq("boblob")
      expect(user.name).to eq("Bob Loblaw")

      expect(User.count).to eq(1)
    end

    it "finds an existing user" do
      FactoryGirl.create(:identity, uid: uid, provider: provider)

      identity = self.described_class.find_or_create_from_omniauth(auth_hash)
      expect(identity.uid).to eq(uid)
    end
  end

end
