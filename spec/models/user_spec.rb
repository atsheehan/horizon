require "rails_helper"

describe User do
  it { should have_many(:identities).dependent(:destroy) }
  it { should have_many(:received_feed_items).dependent(:destroy) }
  it { should have_many(:generated_feed_items).dependent(:destroy) }

  describe '.build_for_views' do
    context 'user from session exists' do
      it 'returns that user from the DB' do
        user = FactoryGirl.create(:user)
        expect(User.build_for_views(user.id)).to eq user
      end
    end

    context 'user from session does not exist' do
      it 'returns a Guest' do
        expect(User.build_for_views(nil)).to be_kind_of(Guest)
      end
    end
  end

  describe '#can_edit?' do
    let(:user) { FactoryGirl.create(:user, role: role) }
    let(:question) { FactoryGirl.create(:question, user: user) }

    context 'user is an admin' do
      let(:role) { "admin" }

      it 'returns true' do
        expect(user.can_edit?(question)).to eq true
      end
    end

    context 'user is not an admin' do
      let(:role) { "member" }

      context 'user created the question' do
        it 'returns true' do
          expect(user.can_edit?(question)).to eq true
        end
      end

      context 'user did not create the question' do
        let(:other_user) { FactoryGirl.create(:user) }

        it 'returns false' do
          expect(other_user.can_edit?(question)).to eq false
        end
      end
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

      user.first_name = "Tony"
      user.last_name = "Montana"
      user.save!

      expect(user.token).to eq(original_token)
    end
  end

  context "requiring launch pass" do
    it "is required if I authenticate via github and I have connected" do
      user = FactoryGirl.create(:github_identity).user
      FactoryGirl.create(:launch_pass_identity, user: user)
      expect(user.require_launch_pass?({
        'provider' => 'github'
      })).to be(true)
    end

    it "is not required if I have only authenticated via github" do
      user = FactoryGirl.create(:github_identity).user
      expect(user.require_launch_pass?({
        'provider' => 'github'
      })).to be(false)
    end

    it "is not required if I authenticate via launch pass and I'm connected" do
      user = FactoryGirl.create(:launch_pass_identity).user
      expect(user.require_launch_pass?({
        'provider' => 'launch_pass'
      })).to be(false)
    end
  end
end
