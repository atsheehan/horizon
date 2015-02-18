require "google/api_client"

class GoogleCalendarAdapter
  attr_reader :calendar_id

  def initialize(calendar_id)
    @calendar_id = calendar_id
  end

  def fetch_events(start_time = nil, end_time = nil)
    request_params = { calendarId: calendar_id }
    request_params[:timeMin] = start_time if start_time
    request_params[:timeMax] = end_time if end_time

    client = google_api_client
    response = client.execute(
      api_method: client.discovered_api("calendar", "v3").events.list,
      parameters: request_params
    )

    json_data = JSON.parse(response.body)
    json_data["items"]
  end

  protected

  def key
    if ENV["GOOGLE_P12_PEM"]
      Rails.logger.debug "#{self.class.name}: Using GOOGLE_P12_PEM PKCS12 " \
        "from the environment."
      return OpenSSL::PKey::RSA.new(ENV["GOOGLE_P12_PEM"], "notasecret")
    end

    keyfile = Dir["#{Rails.root}/*.p12"].first
    if keyfile
      Rails.logger.debug "#{self.class.name}: Using #{keyfile} PKCS12."
      return Google::APIClient::KeyUtils.load_from_pkcs12(keyfile, "notasecret")
    else
      Rails.logger.debug "#{self.class.name}: No PKCS12 found."
    end

    nil
  end

  def oauth2_client
    oauth2_client_params = {
      token_credential_uri: "https://accounts.google.com/o/oauth2/token",
      audience: "https://accounts.google.com/o/oauth2/token",
      scope: "https://www.googleapis.com/auth/calendar.readonly",
      issuer: ENV["GOOGLE_SERVICE_ACCOUNT_EMAIL"],
      signing_key: key
    }

    Signet::OAuth2::Client.new(oauth2_client_params)
  end

  def google_api_client
    api_client_params = {
      application_name: "HorizonDashboard",
      application_version: "0.0.1"
    }

    client = Google::APIClient.new(api_client_params)
    client.authorization = oauth2_client
    client.authorization.fetch_access_token!
    client
  end
end
