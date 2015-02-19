namespace :horizon do
  desc "create default calendar and associate with teams"
  task create_calendar: :environment do
    cid = ENV["DEFAULT_GOOGLE_CALENDAR_ID"]

    if cid.nil? || cid.empty?
      puts "Please set the DEFAULT_GOOGLE_CALENDAR_ID environment variable."
    else
      calendar = Calendar.find_or_create_by!(cid: cid, name: "Default Calendar")
      Team.all.each do |team|
        if team.calendar.nil?
          puts "Set #{team.name} Team to the default calendar."
          team.calendar = calendar
          team.save!
        end
      end
    end
  end
end
