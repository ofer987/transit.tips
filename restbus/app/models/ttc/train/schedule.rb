module Ttc
  module Train
    class Schedule
      attr_reader :line_id, :station, :direction, :items

      def initialize(line_id, station_id, direction, items)
        self.line_id = line_id.to_i
        self.station_id = station_id.to_i
        self.direction = direction.to_s.strip
        self.items = Array(items).map { |item| Item.new(item) }
      end

      def line
        LINES.first { |(_, item)| item[:id] == line_id }
      end

      def station
        line.first { |(_, item)| item[:id] == station_id }
      end

      def as_json(_ = nil)
        {
          subwayLine: line,
          subwayLineId: line_id,
          station: station,
          stationId: station_id,
          direction: direction,
          items: items
        }
      end

      private

      attr_writer :line_id, :station_id, :direction, :items
    end
  end
end
