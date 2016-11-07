module Poller
  class Tweet
    attr_reader :account

    def initialize(account)
      @account = account
    end

    # fetches the last tweet 200 tweets if no last_id was specified
    def fetch(last_id = nil)
      return [] if !last_id.nil? && last_id < 0

      opts = { count: 200 }
      opts[:since_id] = last_id unless last_id.nil?

      Twitter::CLIENT.user_timeline(account, opts)
    end
  end
end
