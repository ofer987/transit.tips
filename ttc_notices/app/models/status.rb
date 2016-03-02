class Status < ActiveRecord::Base
  # id, INTEGER, PKEY, NOT NULL, UNIQUE INDEX
  # tweet_id, INTEGER, NOT NULL, UNIQUE INDEX
  # line_id, NVARCHAR(255), NOT NULL
  # line_type, NVARCHAR(255), NOT NULL
  # description, text, NOT NULL
  # tweeted_at, datetime, NOT NULL
  # created_at, datetime, NOT NULL
  # updated_at, datetime, NOT NULL

  class << self
    def bulk_insert(statuses)
      Array(statuses).each do |status|
        begin
          Status.create!(status)
        rescue ActiveRecord::StatementInvalid => ex
          logger.warn("Error storing the row:\n#{status}\nDetails:#{ex.message}")
        end
      end
    end
  end
end
