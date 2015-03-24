require "rails_helper"

feature "guest creates account" do
  context "new user" do
    scenario "successful sign up" do
      mock_github_auth!

      visit new_session_path

      click_link "Sign In With GitHub"

      expect(page).to have_content("Successfully signed in as boblob")
      expect(page).to have_content("Signed in as boblob")
      expect(page).to have_link("Sign Out", href: session_path)

      expect(User.count).to eq(1)
    end

    scenario "failure to sign up with invalid credentials" do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      visit new_session_path

      click_link "Sign In With GitHub"

      expect(page).to have_content("Unable to sign in.")
      expect(page).to have_link("Sign In With GitHub", new_session_path)
      expect(User.count).to eq(0)
    end
  end

  context "existing user" do
    let(:user) { FactoryGirl.create(:user) }
    let(:identity) { FactoryGirl.create(:identity, user: user) }

    before :each do
      OmniAuth.config.mock_auth[:github] = {
        "provider" => identity.provider,
        "uid" => identity.uid,
        "info" => {
          "nickname" => user.username,
          "email" => user.email,
          "name" => user.name
        },
        "credentials" => {
          "token" => "12345"
        }
      }
    end

    scenario "sign in with github credentials" do
      visit new_session_path
      click_link "Sign In With GitHub"

      expect(page).to have_content("Signed in as #{user.username}")
      expect(page).to have_link("Sign Out", session_path)

      expect(User.count).to eq(1)
    end

    scenario "sign out" do
      visit new_session_path
      click_link "Sign In With GitHub"

      expect(page).to have_content("Signed in as #{user.username}")

      click_link "Sign Out"

      expect(page).to_not have_content("Signed in as #{user.username}")
      expect(page).to have_content("Signed out successfully.")
    end

    scenario "update user attributes from github" do
      OmniAuth.config.mock_auth[:github]["info"]["name"] = "Gary Laser Eyes"

      visit new_session_path
      click_link "Sign In With GitHub"

      visit user_path(user)
      expect(page).to have_content("Gary Laser Eyes")
    end
  end

  context "first time launch pass user" do

  end

  context "github user transitions to launch pass" do
    before(:each) do
      mock_github_auth!
      OmniAuth.config.mock_auth[:launch_pass] = {
        "provider" => "launch_pass",
        "uid" => "123456",
        "info" => {
          "username" => "boblob",
          "email" => "bob@example.com",
          "first_name" => "Bob",
          "last_name" => "Loblaw",
          "teams" => [
            { "id" => 1, "name" => "Admins" },
            { "id" => 2, "name" => "Launchers" }
          ]
        },
        "credentials" => {
          "token" => "12345"
        }
      }
    end

    scenario "first time auth with github" do
      visit new_session_path
      mock_github_auth!
      click_link "Sign In With GitHub"

      expect(page).to have_content("Please associate your Launch Pass account")
      within ".alert-box.warning" do
        click_link "Sign In With Launch Pass"
      end

      expect(page).to have_content(
        "Thanks! Please sign in with Launch Pass moving forward!")
    end

    scenario "post launch pass association" do
      visit new_session_path
      mock_github_auth!
      click_link "Sign In With GitHub"

      expect(page).to have_content("Please associate your Launch Pass account")
      within ".alert-box.warning" do
        click_link "Sign In With Launch Pass"
      end

      expect(page).to have_content(
        "Thanks! Please sign in with Launch Pass moving forward!")

      click_link 'Sign Out'

      visit new_session_path

      click_link "Sign In With GitHub"
      expect(page).to have_content("Please sign in with Launch Pass")

      click_link "Sign In With Launch Pass"
      expect(page).to have_content "Successfully signed in"
    end
  end

  context "first time launch pass user" do
    scenario "unauthorized launch pass user" do
      OmniAuth.config.mock_auth[:launch_pass] = {
        "provider" => "launch_pass",
        "uid" => "123456",
        "info" => {
          "username" => "boblob",
          "email" => "bob@example.com",
          "first_name" => "Bob",
          "last_name" => "Loblaw",
          "teams" => [],
          "product_offerings" => []
        },
        "credentials" => {
          "token" => "12345"
        }
      }

      visit new_session_path
      click_link "Sign In With Launch Pass"

      expect(page).to have_content "Unable to sign in."
    end

    scenario "authorized launch pass user" do
      OmniAuth.config.mock_auth[:launch_pass] = {
        "provider" => "launch_pass",
        "uid" => "123456",
        "info" => {
          "username" => "boblob",
          "email" => "bob@example.com",
          "first_name" => "Bob",
          "last_name" => "Loblaw",
          "teams" => [],
          "product_offerings" => [
            { "id" => "12342", "name" => "On Premises" }
          ]
        },
        "credentials" => {
          "token" => "12345"
        }
      }

      visit new_session_path
      click_link "Sign In With Launch Pass"
      expect(page).to have_content "Successfully signed in"
    end
  end

  def mock_github_auth!
    OmniAuth.config.mock_auth[:github] = {
      "provider" => "github",
      "uid" => "123456",
      "info" => {
        "nickname" => "boblob",
        "email" => "bob@example.com",
        "name" => "Bob Loblaw"
      },
      "credentials" => {
        "token" => "12345"
      }
    }
  end
end
