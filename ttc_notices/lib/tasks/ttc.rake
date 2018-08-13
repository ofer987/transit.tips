namespace :ttc_closures do
  desc 'poll new TTC closures'
  task poll: :environment do
    count = Poller::TtcClosures.new.save_current

    Rails.logger.info("Updated #{count} #{'ttc closure'.pluralize(count)} at #{DateTime.now.inspect}")
  end
end
