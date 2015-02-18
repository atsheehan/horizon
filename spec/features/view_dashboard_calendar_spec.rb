require "rails_helper"

feature "view dashboard calendar" do
  # As a user on my dashboard
  # I want to see upcoming events
  # So that I can be informed about the happenings of the cohort.

  # Acceptance Criteria:
  # - [x] I can see today and tomorrow's events
  # - [x] Events that have already started are shown in a lesser
  #   visual priority
  # - [x] I can click on an event and it links to the event in
  #   the calendar

  let(:user) do
    FactoryGirl.create(
      :user_with_calendar,
      calendar_args: { cid: ENV["DEFAULT_GOOGLE_CALENDAR_ID"] }
    )
  end

  before(:each) do
    Redis.current.flushdb
  end

  after(:each) do
    Redis.current.flushdb
  end

  context "with events in the calendar" do

    before(:each) do
      stub_calendar_start_and_end_time("2015/02/09")
    end

    scenario "user sees event information" do
      sign_in_as(user)
      visit dashboard_path
      expect(page).to have_content("Monday, February 9 at 19:00")
      expect(page).to have_link("Community: Boston MySQL Monthly Meetup")
      expect(page.all("table.calendar tr a").first[:href]).to include 'www.google.com/calendar'
    end

    scenario "events that have already started have a class of '.past-event'" do
      sign_in_as(user)
      visit dashboard_path
      expect(page).to have_css("table.calendar tr.past-event")
      within(first("tr.past-event")) do
        expect(page).to have_content("Past Event")
      end
    end

  end

  context "with no events in the calendar" do

    before(:each) do
      stub_calendar_start_and_end_time("2015/01/31")
    end

    scenario "'no upcoming events' is displayed" do
      sign_in_as(user)
      visit dashboard_path
      expect(page).to have_content("No upcoming events")
    end

  end
end

def stub_calendar_start_and_end_time(datetime_string)
  datetime = DateTime.parse(datetime_string)
  start_time = datetime.beginning_of_day
  end_time = datetime.end_of_day + 1.day

  allow_any_instance_of(Calendar).to receive(:default_start_time)
    .and_return(start_time)

  allow_any_instance_of(Calendar).to receive(:default_end_time)
    .and_return(end_time)
end
