namespace :ttc_closures do
  desc 'poll new TTC closures'
  task poll: :environment do
    # Or get the calendar if already exists in DB
    google_calendar_id = 'ofer.to_v0533re0dqfoe8ns01j2uq90ig@group.calendar.google.com'
    calendar = Calendar.create!(google_calendar_id: google_calendar_id)

    poller = Poller::TtcClosures.new(google_calendar_id, Time.zone.now)
    count = poller.sync_future_closures
    # Rails.logger.info("Updated #{count} #{'ttc closure'.pluralize(count)} at #{DateTime.now.inspect}")

    Ttc::Closure.unpublished.each do |closure|
      poller.publish!(closure)
    rescue => exception
      Rails.logger.error("Failed to publish closure (#{closure.inspect}) to Google Calendar (#{google_calendar_id})")
      Rails.logger.error(exception.message)
      Rails.logger.error(exception.backtrace.join("\n"))
    end
  end
end
