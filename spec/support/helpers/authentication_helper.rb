require "base64"

module AuthenticationHelper
  def sign_in_as(user)
    unless user.identities.first.present?
      FactoryGirl.create(:identity, user: user)
    end

    identity = user.reload.identities.first
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

    visit new_session_path
    click_link "Sign In With GitHub"
  end

  def sign_out
    click_link "Account"
    click_link "Sign Out"
  end

  def set_auth_headers_for(user)
    credentials = Base64.strict_encode64("#{user.username}:#{user.token}")
    request.env["HTTP_AUTHORIZATION"] = "Basic #{credentials}"
  end
end
