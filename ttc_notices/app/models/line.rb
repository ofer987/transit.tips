class Line < ActiveModelSerializers::Model
  class << self
    def find(id, options = {})
      statuses = Status.where(line_id: id)

      if options.has_key?(:tweeted_by)
        statuses = statuses
          .where('tweeted_at >= ? AND tweeted_at <= ?', options[:tweeted_by].utc, DateTime.now.utc)
      end

      if options.has_key?(:limit)
        statuses = statuses.limit(options[:limit])
      end

      if statuses.any?
        Line.new.tap do |line|
          line.id = id
          line.statuses = statuses
        end
      else
        Line::Null.new
      end
    end
  end

  attr_accessor :id, :statuses

  alias :read_attribute_for_serialization :send

  def empty?
    statuses.empty?
  end
end
