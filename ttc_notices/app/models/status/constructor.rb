class Status
  class Constructor
    class << self
      # TODO: move to twitter:poll task
      def insert_latest_statuses!(account)
        tweets = Poller::Tweet.new(account).fetch(Status.last_status.tweet_id)
        statuses = new(tweets).build

        Status.bulk_insert!(statuses)
      end
    end

    attr_reader :tweets

    def initialize(tweets)
      # TODO: move to Pollere::Tweet#fetch
      @tweets = Array(tweets).map(&:to_h)
    end

    # TODO: move to Poller::Tweet
    def build
      tweets.flat_map do |tweet|
        get_line_ids(tweet[:text]).map do |line_id|
          {
            tweet_id: tweet[:id],
            line_id: line_id,
            line_type: get_line_type(line_id),
            description: tweet[:text],
            tweeted_at: get_time(tweet[:created_at]).utc
          }
        end
      end
    end

    private

    # TODO: move to Status

    def get_line_ids(description)
      description.scan(/\d+/).map(&:to_i)
    end

    def get_line_type(line_id)
      case line_id
      when 1..4
        'Train'
      when 301, 304, 306, 317
        'Streetcar'
      when 5..499
        'Bus'
      when 500..515
        'Streetcar'
      else
        'Bus'
      end
    end

    def get_time(str)
      DateTime.strptime(str, '%a %b %d %H:%M:%S %z %Y')
    end
  end
end
