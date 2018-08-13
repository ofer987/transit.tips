namespace :ttc_closures do
  desc 'poll new TTC closures'
  task poll: :environment do
    begin
    poller = Poller::TtcClosures.new
    count = poller.save_current
    Rails.logger.info("Updated #{count} #{'ttc closure'.pluralize(count)} at #{DateTime.now.inspect}")

    calendar_id = 'ofer.to_v0533re0dqfoe8ns01j2uq90ig@group.calendar.google.com'
    current_events = Ttc::Closure.current.map(&:to_event)

    poller.publish(calendar_id, current_events)
    Rails.logger.info("Published #{current_events.size} #{'event'.pluralize(current_events.size)} to Google Calendar (#{calendar_id})")

    rescue => exception
      Rails.logger.error('Failed to publish new events to Google Calendar')
      Rails.logger.error(exception.message)
      Rails.logger.error(exception.backtrace.join("\n"))
    end
  end
end
