module Ttc
  module Train
    class Schedule
      attr_reader :line, :station, :direction, :items

      def initialize(line, station, direction, items)
        self.line = line.to_s.strip
        self.station = station.to_s.strip
        self.direction = direction.to_s.strip
        self.items = Array(items).map { |item| Item.new(item) }
      end

      def line_id
        LINES[line]
      end

      def station_id
        STATIONS[station]
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

      attr_writer :line, :station, :direction, :items
    end
  end
end
