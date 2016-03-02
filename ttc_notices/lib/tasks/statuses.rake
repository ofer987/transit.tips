namespace :statuses do
  desc "Fetch new statuses and persist in database"
  task fetch: :environment do
    tweets = Poller::Tweet.new('@ttcnotice').fetch(last_tweet_id)

    statuses = Status::Constructor.new(tweets).build

    Status.transaction do
      Status.bulk_insert(statuses)
    end
  end

  private

  def last_tweet_id
    status = Status
      .order(tweet_id: :desc)
      .limit(1)
      .pluck(:tweet_id)

    status[0]
  end
end
