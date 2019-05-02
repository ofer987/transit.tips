module Ttc
  module Train
    class Schedule
      attr_reader :line_id, :station_id, :destination_station, :events

      def initialize(line_id, station_id, destination_station, events)
        self.line_id = line_id.to_i
        self.station_id = station_id.to_i
        self.destination_station = destination_station.to_s.strip
        self.events = Array(events).map { |time| Event.new(time) }
      end

      def line
        @line ||= LINES
          .values
          .select { |item| item[:id] == line_id }
          .first
      end

      def stations
        @stations ||= line[:stations].values
      end

      def station
        @station ||= stations
          .select { |item| item[:id] == station_id }
          .first
      end

      def as_json(_ = nil)
        {
          line: line[:name],
          line_id: line_id,
          station: station[:name],
          station_id: station_id,
          destination_station: destination_station,
          events: events.as_json
        }
      end

      private

      attr_writer :line_id, :station_id, :destination_station, :events
    end
  end
end
