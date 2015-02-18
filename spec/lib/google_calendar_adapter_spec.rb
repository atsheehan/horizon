require "rails_helper"

RSpec.describe GoogleCalendarAdapter do
  describe "#fetch_events" do
    let(:calendar) do
      GoogleCalendarAdapter.new(ENV["DEFAULT_GOOGLE_CALENDAR_ID"])
    end

    it "should return a array of event data" do
      events = calendar.fetch_events
      expect(events).to be_an Array
      expect(events.first["kind"]).to eq("calendar#event")
    end

    it "should scope events to a date range" do
      start_time = DateTime.parse("2015/01/26").beginning_of_day
      end_time = DateTime.parse("2015/01/30").end_of_day
      events = calendar.fetch_events(start_time, end_time)
      event_time = DateTime.parse(events.first["start"]["dateTime"])

      expect(event_time).to be_between(start_time, end_time)
    end
  end
end
