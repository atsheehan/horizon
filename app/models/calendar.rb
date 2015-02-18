class Calendar < ActiveRecord::Base
  has_many :teams

  validates :name, presence: true
  validates :cid, presence: true
  validates :cid, uniqueness: true

  def events_json
    # return events if stored in redis
    if redis.get(cid)
      api_calendar_data = JSON.parse(redis.get(cid))
      return api_calendar_data unless api_calendar_data.empty?
    end

    # fetch events and store in redis
    result = GoogleCalendarAdapter.new(cid)
      .fetch_events(default_start_time, default_end_time)
    redis.set(cid, result.to_json)
    redis.expire(cid, 15.minutes)

    result
  end

  def events
    results = events_json.map { |json| CalendarEvent.new(event_json(json)) }
    results.reject { |event| event.start_time.nil? || event.end_time.nil? }
  end

  def default_start_time
    DateTime.now.beginning_of_day
  end

  def default_end_time
    DateTime.now.end_of_day + 1.day
  end

  def redis
    Redis.current
  end

  def self.events(calendar_ids)
    results = []
    calendar_ids.each do |calendar_id|
      results.concat(Calendar.find(calendar_id).events)
    end

    results.sort_by { |event| event.start_time }
  end

  private

  def event_json(json)
    {
      start_time: parse_date_string(json, "start"),
      end_time: parse_date_string(json, "end"),
      summary: json["summary"],
      url: json["htmlLink"]
    }
  end

  def parse_date_string(json, key)
    return nil unless json[key]

    if json[key]["date"]
      Date.parse(json[key]["date"])
    elsif json[key]["dateTime"]
      DateTime.parse(json[key]["dateTime"])
    else
      nil
    end
  end
end
