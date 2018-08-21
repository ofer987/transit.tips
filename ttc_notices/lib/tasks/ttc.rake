namespace :ttc_closures do
  # TODO: rename to sync
  desc 'poll new TTC closures'
  task poll: :environment do
    calendar = Calendar.find_or_create_by!(
      google_calendar_id: 'ofer.to_v0533re0dqfoe8ns01j2uq90ig@group.calendar.google.com',
      name: 'TTCC'
    )

    poller = Poller::TtcClosures.new(calendar, Time.zone.now)

    Rails.logger.info('Fetch new closures and delete cancelled closures')
    begin
      poller.sync_future_closures!
    rescue => exception
      Rails.logger.error("Failed to synchronise future closures to Google Calendar (#{calendar.google_calendar_id})")
      Rails.logger.error(exception.message)
      Rails.logger.error(exception.backtrace.join("\n"))
      exit false
    end

    Rails.logger.info('Publish new closures')
    Ttc::Closure.unpublished.each do |closure|
      begin
        poller.publish!(closure)
      rescue => exception
        Rails.logger.error("Failed to publish closure (#{closure.inspect}) to Google Calendar (#{calendar.google_calendar_id})")
        Rails.logger.error(exception.message)
        Rails.logger.error(exception.backtrace.join("\n"))
      end
    end
  end

  desc 'Fetch google calendar events'
  task list: :environment do
    calendar = Calendar.find_or_create_by!(
      google_calendar_id: 'ofer.to_v0533re0dqfoe8ns01j2uq90ig@group.calendar.google.com',
      name: 'TTCC'
    )

    puts 'List Google Calendar events'
    Poller::TtcClosures.new(calendar, Time.zone.now).list.each do |event|
      puts event
    end
  end
end
