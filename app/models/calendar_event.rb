class CalendarEvent
  attr_reader :summary, :url, :start_time, :end_time

  def initialize(data)
    @start_time = data[:start_time]
    @end_time = data[:end_time]
    @summary = data[:summary]
    @url = data[:url]
  end
end
