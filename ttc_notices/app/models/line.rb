class Line
  class << self
    def find_statuses(id, options = {})
      statuses = Status.where(line_id: id)
      if options.has_key?(:tweeted_by)
        statuses = statuses
          .where('tweeted_at >= ? AND tweeted_at <= ?', options[:tweeted_by].utc, DateTime.now.utc)
      end

      if options.has_key?(:limit)
        statuses = statuses.limit(options[:limit])
      end

      statuses
    end
  end
end
