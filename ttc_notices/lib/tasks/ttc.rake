namespace :ttc_closures do
  desc 'poll new TTC closures'
  task poll: :environment do
    begin
    poller = Poller::TtcClosures.new
    count = poller.save_current
    Rails.logger.info("Updated #{count} #{'ttc closure'.pluralize(count)} at #{DateTime.now.inspect}")

    google_calendar_id = 'ofer.to_v0533re0dqfoe8ns01j2uq90ig@group.calendar.google.com'
    Ttc::Closure.current.each do |event|
      begin
        poller.publish(google_calendar_id, event)
        Rails.logger.info("Published #{published_count} #{'event'.pluralize(published_count)} to Google Calendar (#{google_calendar_id})")
      rescue => exception
        Rails.logger.error("Failed to publish event (#{event.inspect}) to Google Calendar (#{google_calendar_id})")
        Rails.logger.error(exception.message)
        Rails.logger.error(exception.backtrace.join("\n"))
      end
    end
  end
end
