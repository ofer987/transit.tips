class Status
  class Constructor
    attr_reader :tweets

    def initialize(tweets)
      @tweets = Array(tweets).map(&:to_h)
    end

    def build
      tweets.flat_map do |tweet|
        get_line_ids(tweet[:text]).map do |line_id|
          {
            tweet_id: tweet[:id],
            line_id: line_id,
            type: get_type(line_id),
            description: tweet[:text],
            tweeted_at: get_time(tweet[:created_at]).utc
          }
        end
      end
    end

    private

    def get_line_ids(description)
      description.scan(/\d+/).map(&:to_i)
    end

    def get_type(line_id)
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
