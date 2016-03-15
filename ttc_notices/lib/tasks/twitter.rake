namespace :twitter do
  desc 'poll new tweets from twitter'
  task poll: :environment do
    count = Status::Constructor.insert_latest_statuses!('@TTCNotices')

    Rails.logger.info("Updated #{count} #{'status'.pluralize(count)} at #{DateTime.now.inspect}")
  end
end
