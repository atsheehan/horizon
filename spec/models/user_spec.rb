require "rails_helper"

describe User do
  it { should have_many(:received_feed_items).dependent(:destroy) }
  it { should have_many(:generated_feed_items).dependent(:destroy) }

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
      user = User.find_or_create_from_omniauth(auth_hash)

      expect(user.uid).to eq(uid)
      expect(user.provider).to eq(provider)

      expect(user.email).to eq("bob@example.com")
      expect(user.username).to eq("boblob")
      expect(user.name).to eq("Bob Loblaw")

      expect(User.count).to eq(1)
    end

    it "finds an existing user" do
      FactoryGirl.create(:user, uid: uid, provider: provider)

      user = User.find_or_create_from_omniauth(auth_hash)
      expect(user.uid).to eq(uid)

      expect(User.count).to eq(1)
    end
  end

  describe "token authentication" do
    it "generates a random token when first saving" do
      user = FactoryGirl.build(:user)
      expect(user.token).to eq(nil)

      user.save!
      expect(user.token).to_not eq(nil)
    end

    it "does not change token when updating a user" do
      user = FactoryGirl.create(:user)
      original_token = user.token

      user.name = "Tony Montana"
      user.save!

      expect(user.token).to eq(original_token)
    end
  end
end
